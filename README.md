# Dotfiles

Professional, minimalist, and high-performance development environment for macOS.

## 🚀 Overview
This repository contains my personal configuration files for a streamlined developer experience.

- **Fish Shell**: Modern, user-friendly shell with smart auto-suggestions.
- **Starship**: Lightning-fast, minimalist, and context-aware prompt.
- **Git**: Advanced global configuration with professional defaults.
- **VS Code**: Optimized `settings.json` focused on productivity and clean UI.
- **Brewfile**: Automated management of all macOS applications and CLI tools.

## 🛠️ Installation

### 1. Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run the Installation Script
The script will install Homebrew (if missing), all packages from the Brewfile, and create symbolic links for all configurations.
```bash
chmod +x install.sh
./install.sh
```

## 📦 Maintenance

### Update Brewfile
Whenever you install or remove an app via Homebrew, update your Brewfile:
```bash
brew bundle dump --describe --force --file=~/dotfiles/Brewfile
```

### Sync Changes
To push your latest local config changes to GitHub:
```bash
cd ~/dotfiles
git add .
git commit -m "chore(config): update dotfiles"
git push
```
