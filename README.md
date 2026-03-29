# Dotfiles

Professional, minimalist, and high-performance development environment for macOS.

## 🚀 Overview
This repository contains my personal configuration files for a streamlined developer experience.

- **Fish Shell**: Modern, user-friendly shell with smart auto-suggestions.
- **Starship**: Lightning-fast, minimalist, and context-aware prompt.
- **Git**: Advanced global configuration with professional defaults.
- **VS Code**: Optimized `settings.json` focused on productivity and clean UI.
- **Brewfile**: Automated management of all macOS applications and CLI tools.
- **Nerd Fonts**: Custom script to install essential fonts for developers.

## 🛠️ Installation

### 1. Clone the Repository
```bash
git clone https://github.com/burakkaygusuz/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Install Packages & Configs
```bash
chmod +x install.sh
./install.sh
```

### 3. Install Nerd Fonts (Optional)
```bash
chmod +x fonts.sh
./fonts.sh
```

## 📦 Maintenance

### Update Brewfile
```bash
brew bundle dump --describe --force --file=~/dotfiles/Brewfile
```

### Sync Changes
```bash
cd ~/dotfiles
git add .
git commit -m "chore(config): update dotfiles"
git push
```

---
