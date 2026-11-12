#!/bin/bash
# Runs once: chsh prompts for a password on every call.
set -euo pipefail
fish=/opt/homebrew/bin/fish
[ -x "$fish" ] || { echo "fish not found at $fish. Run brew bundle first." >&2; exit 1; }
grep -qxF "$fish" /etc/shells || echo "$fish" | sudo tee -a /etc/shells >/dev/null
if [ "$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')" != "$fish" ]; then
  chsh -s "$fish"
fi
