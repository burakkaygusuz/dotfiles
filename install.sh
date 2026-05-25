#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_HOME="$HOME"

ensure_brew_env() {
  if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
    return 0
  fi

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    return 0
  fi

  return 1
}

link_config() {
  local source="$1"
  local target="$2"
  local target_dir

  target_dir="$(dirname "$target")"
  mkdir -p "$target_dir"
  ln -sfn "$source" "$target"
}

current_login_shell() {
  if command -v dscacheutil >/dev/null 2>&1; then
    dscacheutil -q user -a name "$(id -un)" 2>/dev/null | awk '/^shell: / { print $2; exit }'
    return 0
  fi

  printf '%s\n' "${SHELL:-}"
}

ensure_default_fish_shell() {
  if [ "${DOTFILES_SKIP_DEFAULT_SHELL:-0}" = "1" ]; then
    echo "DOTFILES_SKIP_DEFAULT_SHELL=1: skipping default shell update."
    return 0
  fi

  local fish_path
  local current_shell

  fish_path="$(command -v fish || true)"
  if [ -z "$fish_path" ]; then
    echo "fish is not installed; skipping default shell update."
    return 0
  fi

  current_shell="$(current_login_shell)"
  if [ "$current_shell" = "$fish_path" ]; then
    echo "Fish is already the default shell."
    return 0
  fi

  if [ ! -r /etc/shells ] || ! grep -qxF "$fish_path" /etc/shells; then
    echo "Fish is installed at $fish_path but is not registered in /etc/shells."
    echo "Run: echo '$fish_path' | sudo tee -a /etc/shells"
    echo "Then run: chsh -s '$fish_path'"
    return 0
  fi

  if [ -t 0 ]; then
    echo "Changing default shell to fish..."
    if chsh -s "$fish_path"; then
      echo "Default shell updated to fish."
    else
      echo "Could not change the default shell automatically."
      echo "Run: chsh -s '$fish_path'"
    fi
  else
    echo "To make fish the default shell, run: chsh -s '$fish_path'"
  fi
}

setup_wrappers() {
  echo "Setting up command wrappers..."
  mkdir -p "$TARGET_HOME/.local/bin"

  if [ ! -f "$TARGET_HOME/.local/bin/find" ]; then
    cat > "$TARGET_HOME/.local/bin/find" <<'EOF'
#!/usr/bin/env bash
exec bfs "$@"
EOF
    chmod +x "$TARGET_HOME/.local/bin/find"
  fi

  if [ ! -f "$TARGET_HOME/.local/bin/grep" ]; then
    cat > "$TARGET_HOME/.local/bin/grep" <<'EOF'
#!/usr/bin/env bash
exec ugrep "$@"
EOF
    chmod +x "$TARGET_HOME/.local/bin/grep"
  fi
}

install_homebrew() {
  echo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

is_apple_silicon() {
  local machine

  machine="$(uname -m)"
  if [ "$machine" = "arm64" ]; then
    return 0
  fi

  if [ "$machine" = "x86_64" ]; then
    [ "$(sysctl -in sysctl.proc_translated 2>/dev/null || true)" = "1" ]
    return $?
  fi

  return 1
}

if [ "$(uname -s)" != "Darwin" ]; then
  echo "This dotfiles repository supports Apple Silicon macOS only." >&2
  exit 1
fi

if ! is_apple_silicon; then
  echo "This dotfiles repository supports Apple Silicon Macs only." >&2
  exit 1
fi

if [ "${DOTFILES_SKIP_BREW:-0}" = "1" ]; then
  echo "DOTFILES_SKIP_BREW=1: skipping Homebrew bootstrap."
else
  if ! ensure_brew_env; then
    install_homebrew
    ensure_brew_env
  fi

  if [ -f "$REPO_ROOT/Brewfile" ]; then
    if brew bundle check --file="$REPO_ROOT/Brewfile" >/dev/null 2>&1; then
      echo "Brewfile already satisfied."
    else
      brew bundle --file="$REPO_ROOT/Brewfile"
    fi
  fi
fi

link_config "$REPO_ROOT/fish/config.fish" "$TARGET_HOME/.config/fish/config.fish"
link_config "$REPO_ROOT/zsh/.zshrc" "$TARGET_HOME/.zshrc"
link_config "$REPO_ROOT/starship/starship.toml" "$TARGET_HOME/.config/starship.toml"
link_config "$REPO_ROOT/git/.gitconfig" "$TARGET_HOME/.gitconfig"
link_config "$REPO_ROOT/git/.gitignore_global" "$TARGET_HOME/.gitignore_global"
link_config "$REPO_ROOT/ghostty/config" "$TARGET_HOME/.config/ghostty/config"
link_config "$REPO_ROOT/vscode/settings.json" "$TARGET_HOME/Library/Application Support/Code/User/settings.json"

setup_wrappers
ensure_default_fish_shell
