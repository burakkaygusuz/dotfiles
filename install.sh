#!/bin/bash

# Dotfiles Installation Script
# Professional & Minimalist Environment Setup

set -e

echo "Starting installation..."

# 1. Install Homebrew if not found
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

# 2. Install all dependencies from Brewfile
if [ -f "Brewfile" ]; then
    echo "Installing packages from Brewfile..."
    brew bundle --file=Brewfile
else
    echo "Brewfile not found, skipping package installation."
fi

# 3. Create necessary directories
echo "Creating configuration directories..."
mkdir -p ~/.config/fish
mkdir -p ~/.config/ghostty
mkdir -p "$HOME/Library/Application Support/Code/User"

# 4. Create Symbolic Links (Overwrites existing files)
echo "Linking configuration files..."

# Fish
ln -sf "$HOME/dotfiles/fish/config.fish" "$HOME/.config/fish/config.fish"

# Starship
ln -sf "$HOME/dotfiles/starship/starship.toml" "$HOME/.config/starship.toml"

# Git
ln -sf "$HOME/dotfiles/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$HOME/dotfiles/git/.gitignore_global" "$HOME/.gitignore_global"

# Ghostty
ln -sf "$HOME/dotfiles/ghostty/config" "$HOME/.config/ghostty/config"

# VS Code
ln -sf "$HOME/dotfiles/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

echo "Installation completed successfully!"
echo "Note: Please restart your terminal to apply changes."
