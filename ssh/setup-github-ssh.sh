#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: setup-github-ssh.sh --email you@example.com [--key-name id_ed25519]

Bootstraps a GitHub SSH key on macOS without overwriting existing SSH config.

Options:
  --email       Label for the SSH key. Required.
  --key-name    Private key filename under ~/.ssh (default: id_ed25519)
  -h, --help    Show this help text
EOF
}

if [ "$(uname -s)" != "Darwin" ]; then
  echo "This script supports macOS only." >&2
  exit 1
fi

email=""
key_name="id_ed25519"

while [ "$#" -gt 0 ]; do
  case "$1" in
  --email)
    email="${2:-}"
    shift 2
    ;;
  --key-name)
    key_name="${2:-}"
    shift 2
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown argument: $1" >&2
    usage >&2
    exit 1
    ;;
  esac
done

if [ -z "$email" ]; then
  echo "Missing --email." >&2
  usage >&2
  exit 1
fi

key_name="$(basename "${key_name:-id_ed25519}")"

ssh_dir="$HOME/.ssh"
config_dir="$ssh_dir/config.d"
main_config="$ssh_dir/config"
managed_config="$config_dir/github-dotfiles.conf"
key_path="$ssh_dir/$key_name"
pub_key_path="$key_path.pub"
include_line="Include ~/.ssh/config.d/*.conf"

ensure_include_at_top() {
  local file="$1"
  local line="$2"
  local tmp_file

  tmp_file="$(mktemp "${TMPDIR:-/tmp}/setup-github-ssh.XXXXXX")"
  trap 'rm -f "$tmp_file"' RETURN

  {
    printf '%s\n' "$line"
    if [ -s "$file" ]; then
      awk -v include_line="$line" '$0 != include_line { print }' "$file"
    fi
  } >"$tmp_file"

  mv "$tmp_file" "$file"
  trap - RETURN
}

mkdir -p "$ssh_dir" "$config_dir"
chmod 700 "$ssh_dir" "$config_dir"

if [ ! -f "$key_path" ]; then
  echo "Generating SSH key at $key_path..."
  ssh-keygen -t ed25519 -C "$email" -f "$key_path"
else
  echo "SSH key already exists at $key_path"
fi

chmod 600 "$key_path"
[ -f "$pub_key_path" ] && chmod 644 "$pub_key_path"

touch "$main_config"
chmod 600 "$main_config"

if grep -qE '^[[:space:]]*Host[[:space:]]+github\.com([[:space:]]|$)' "$main_config"; then
  echo "Warning: $main_config already contains a Host github.com entry." >&2
fi

ensure_include_at_top "$main_config" "$include_line"

cat >"$managed_config" <<EOF
Host github.com
  IgnoreUnknown UseKeychain
  AddKeysToAgent yes
  UseKeychain yes
  IdentitiesOnly yes
  IdentityFile $key_path
EOF
chmod 600 "$managed_config"

echo "Adding key to ssh-agent and Apple keychain..."
ssh-add --apple-use-keychain "$key_path"

echo "Configuring Git SSH signing in ~/.gitconfig.local..."
git config --file "$HOME/.gitconfig.local" user.signingkey "$pub_key_path"
git config --file "$HOME/.gitconfig.local" commit.gpgsign true
git config --file "$HOME/.gitconfig.local" tag.gpgsign true

echo
echo "GitHub SSH bootstrap complete."
echo "Public key: $pub_key_path"
if [ -f "$pub_key_path" ]; then
  echo "Fingerprint:"
  ssh-keygen -lf "$pub_key_path"
fi
echo "Copy it with:"
echo "  pbcopy < \"$pub_key_path\""
echo "Then add it to your GitHub account (Settings -> SSH and GPG Keys -> New SSH Key, Key type: Authentication & Signing Key)"
echo "Test authentication with:"
echo "  make verify-ssh"
