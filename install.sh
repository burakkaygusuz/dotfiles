#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_HOME="$HOME"

ensure_brew_env() {
  if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
    return 0
  fi

  local brew_path
  for brew_path in \
    /opt/homebrew/bin/brew \
    /usr/local/bin/brew \
    /home/linuxbrew/.linuxbrew/bin/brew
  do
    if [ -x "$brew_path" ]; then
      eval "$("$brew_path" shellenv)"
      return 0
    fi
  done

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
  if [ "$(uname -s)" = "Darwin" ] && command -v dscacheutil >/dev/null 2>&1; then
    dscacheutil -q user -a name "$(id -un)" 2>/dev/null | awk '/^shell: / { print $2; exit }'
    return 0
  fi

  if command -v getent >/dev/null 2>&1; then
    getent passwd "$(id -un)" | cut -d: -f7
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

install_homebrew() {
  echo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

if [ "${DOTFILES_SKIP_BREW:-0}" = "1" ]; then
  echo "DOTFILES_SKIP_BREW=1: skipping Homebrew bootstrap."
else
  if ! ensure_brew_env; then
    install_homebrew
    ensure_brew_env
  fi

  if [ -f "$REPO_ROOT/Brewfile" ] && [ "$(uname -s)" = "Darwin" ]; then
    brew bundle --file="$REPO_ROOT/Brewfile"
  elif [ -f "$REPO_ROOT/Brewfile" ]; then
    echo "Non-macOS detected: skipping Brewfile bundle."
  fi
fi

link_config "$REPO_ROOT/fish/config.fish" "$TARGET_HOME/.config/fish/config.fish"
link_config "$REPO_ROOT/starship/starship.toml" "$TARGET_HOME/.config/starship.toml"
link_config "$REPO_ROOT/git/.gitconfig" "$TARGET_HOME/.gitconfig"
link_config "$REPO_ROOT/git/.gitignore_global" "$TARGET_HOME/.gitignore_global"
link_config "$REPO_ROOT/ghostty/config" "$TARGET_HOME/.config/ghostty/config"
link_config "$REPO_ROOT/vscode/settings.json" "$TARGET_HOME/Library/Application Support/Code/User/settings.json"

ensure_default_fish_shell

if command -v git-lfs >/dev/null 2>&1; then
  git lfs install --skip-repo
fi
