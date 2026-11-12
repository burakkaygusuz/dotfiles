#!/usr/bin/env bash
# Creates the GitHub SSH key if missing, loads it into the Keychain, and uploads it
# for authentication and signing. Safe to re-run. Run once, then run `chezmoi apply`.
set -euo pipefail

# Log in and add the scopes needed to upload keys, before any key work.
gh auth status >/dev/null 2>&1 || gh auth login -h github.com -p ssh -w
scopes=$(gh auth status 2>&1 || true)
[[ $scopes == *admin:public_key* && $scopes == *admin:ssh_signing_key* ]] || gh auth refresh -h github.com -s admin:public_key,admin:ssh_signing_key

email=$(git config --global user.email) || { echo "No user.email in ~/.gitconfig. Run chezmoi apply first." >&2; exit 1; }
key="$HOME/.ssh/id_ed25519"

if [ ! -f "$key" ]; then
  ssh-keygen -t ed25519 -C "$email" -f "$key"
elif [ ! -f "$key.pub" ]; then
  ssh-keygen -y -f "$key" >"$key.pub"
fi

ssh-add --apple-use-keychain "$key"

# Skips keys GitHub already has, so a re-run after a partial upload succeeds.
upload() {
  local keys
  keys=$(gh api --paginate "$1" --jq '.[].key')
  if grep -qxF "$(cut -d' ' -f1-2 "$key.pub")" <<<"$keys"; then
    echo "Already uploaded: $2 key."
  else
    gh ssh-key add "$key.pub" --type "$2" --title "dotfiles-$(hostname -s)"
  fi
}
upload user/keys authentication
upload user/ssh_signing_keys signing

echo "Uploaded. Run: chezmoi apply (writes ~/.ssh/config, allowed_signers and git signing config)."
