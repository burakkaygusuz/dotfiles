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
    -h|--help)
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

ssh_dir="$HOME/.ssh"
config_dir="$ssh_dir/config.d"
main_config="$ssh_dir/config"
managed_config="$config_dir/github-dotfiles.conf"
key_path="$ssh_dir/$key_name"
pub_key_path="$key_path.pub"
include_line="Include ~/.ssh/config.d/*.conf"

mkdir -p "$ssh_dir" "$config_dir"
chmod 700 "$ssh_dir"

if [ ! -f "$key_path" ]; then
  echo "Generating SSH key at $key_path..."
  ssh-keygen -t ed25519 -C "$email" -f "$key_path"
else
  echo "SSH key already exists at $key_path"
fi

touch "$main_config"
chmod 600 "$main_config"

if ! grep -qxF "$include_line" "$main_config"; then
  printf '%s\n' "$include_line" >> "$main_config"
fi

cat > "$managed_config" <<EOF
Host github.com
  IgnoreUnknown UseKeychain
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $key_path
EOF
chmod 600 "$managed_config"

echo "Adding key to ssh-agent and Apple keychain..."
ssh-add --apple-use-keychain "$key_path"

echo
echo "GitHub SSH bootstrap complete."
echo "Public key: $pub_key_path"
echo "Copy it with:"
echo "  pbcopy < \"$pub_key_path\""
echo "Then add it to your GitHub account and test with:"
echo "  ssh -T git@github.com"
