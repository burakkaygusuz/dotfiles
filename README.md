# Dotfiles

Professional, minimalist, and high-performance development environment for Apple Silicon macOS.

## 🚀 Overview

This repository contains my personal configuration files for a streamlined developer experience.

- **Fish Shell**: Modern, user-friendly shell with smart auto-suggestions.
- **Starship**: Lightning-fast, minimalist, and context-aware prompt.
- **Ghostty**: High-performance GPU-accelerated terminal emulator.
- **Git**: Advanced global configuration with professional defaults.
- **VS Code**: Optimized `settings.json` focused on productivity and clean UI.
- **Brewfile**: Automated management of all macOS applications and CLI tools.
- **GNU Stow**: Declarative, conflict-free symlink management.
- **Nerd Fonts**: Custom script to install essential fonts for developers.

## 🛠️ Installation

This repository uses a staged setup flow.
`make all` handles the core package/config bootstrap, but a complete machine setup may also require the optional font and GitHub SSH steps below.

### 1. Clone the Repository

```bash
git clone https://github.com/burakkaygusuz/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run the Core Bootstrap

```bash
make all
```

You can also run individual targets like `make brew`, `make symlinks`, `make wrappers`, or `make shell`. Run `make help` for all options.

This repository targets Apple Silicon Macs only and assumes Homebrew is installed in `/opt/homebrew`.
Prefer running the installer from a native Apple Silicon shell for the most predictable behavior.
`make shell` also tries to make `fish` your default login shell after installation.
If `fish` is not registered in `/etc/shells`, you will be prompted for your password to add it.

### 3. Install Nerd Fonts (Recommended)

```bash
chmod +x fonts.sh
./fonts.sh
```

This step installs the Nerd Fonts referenced by the terminal and editor configuration.

### 4. Bootstrap GitHub SSH (Optional)

The SSH bootstrap is intentionally separate from `install.sh`.
It can create an `ed25519` key if needed, add a managed GitHub host block via `~/.ssh/config.d/github-dotfiles.conf`, and load the key into the macOS keychain without overwriting your existing SSH config.
The script requires an explicit `--email` argument for the SSH key label.

```bash
chmod +x ssh/setup-github-ssh.sh
./ssh/setup-github-ssh.sh --email you@example.com
```

After the script completes:

```bash
pbcopy < ~/.ssh/id_ed25519.pub
ssh -T git@github.com
```

If you already have custom `Host github.com` rules in `~/.ssh/config`, review them after running the script. The bootstrap inserts its managed include first, but conflicting host-specific SSH settings may still need manual cleanup. If any Host github.com rules remain, merge them carefully.

You still need to add the copied public key to your GitHub account before SSH authentication will work.

### 5. Restart and Verify

After the steps above:

- Restart your terminal session so the default shell and prompt changes are applied cleanly.
- Open VS Code again if you want the updated terminal/profile settings to take effect.
- If `make shell` prompted you for a password to change the shell, ensure it succeeded.

## 📦 Maintenance

### Update Brewfile

```bash
brew bundle dump --describe --force --file=~/dotfiles/Brewfile
```

### Cleanup packages not in Brewfile

```bash
brew bundle cleanup --file=~/dotfiles/Brewfile --force
```

### Troubleshooting

```bash
brew doctor
```

### Sync Changes

```bash
cd ~/dotfiles
git add .
git commit -m "chore(config): update dotfiles"
git push
```

---
