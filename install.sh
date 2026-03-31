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

if command -v git-lfs >/dev/null 2>&1; then
  git lfs install --skip-repo
fi
