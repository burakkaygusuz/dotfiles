# Dotfiles

Professional, minimalist, and high-performance development environment for Apple Silicon macOS.

## 🚀 Overview

This repository contains my personal configuration files for a streamlined developer experience.

- **Fish Shell**: Canonical daily-driver interactive login shell with auto-suggestions.
- **Zsh**: Fully configured native macOS fallback shell (`.zshrc`).
- **Starship**: Lightning-fast, minimalist, and context-aware prompt.
- **Ghostty**: High-performance GPU-accelerated terminal emulator.
- **Git**: Advanced global configuration with professional defaults.
- **VS Code**: Optimized `settings.json` focused on productivity and clean UI.
- **Brewfile**: Automated management of all macOS applications and CLI tools.
- **Chezmoi**: Modern, secure, and declarative dotfiles management.
- **Nerd Fonts**: Curated developer fonts managed via Homebrew casks.

## 🛠️ Installation

### 1. Clone the Repository

```bash
git clone https://github.com/burakkaygusuz/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run the Core Bootstrap

```bash
make all
```

`make all` installs Homebrew packages (including Nerd Fonts), applies dotfiles via Chezmoi, and configures `fish` as the default login shell.

You can also inspect changes before applying or run individual targets:

- `make diff` — Preview differences between this repo and your `$HOME` files.
- `make symlinks` — Apply dotfiles safely (Chezmoi prompts if a local file was modified).
- `make symlinks-force` — Force overwrite local changes with repo versions.
- `make brew` / `make shell` — Run package install or shell setup independently.

This repository targets Apple Silicon Macs only and assumes Homebrew is installed in `/opt/homebrew`.
If `fish` is not registered in `/etc/shells`, you will be prompted for your password to add it.

### 3. Bootstrap GitHub SSH (Optional)

The SSH bootstrap is intentionally separate from `install.sh`.
It can create an `ed25519` key if needed, add a managed GitHub host block via `~/.ssh/config.d/github-dotfiles.conf`, and load the key into the macOS keychain without overwriting your existing SSH config.
The script requires an explicit `--email` argument for the SSH key label.

```bash
chmod +x ssh/setup-github-ssh.sh
./ssh/setup-github-ssh.sh --email you@example.com
```

After the script completes:

```bash
# Copy the public key printed by the script (or default ~/.ssh/id_ed25519.pub):
pbcopy < ~/.ssh/id_ed25519.pub

# Test connection and effective config:
make verify-ssh
```

If you already have custom `Host github.com` rules in `~/.ssh/config`, review them after running the script. The bootstrap inserts its managed include first (with `IdentitiesOnly yes` for conflict-free multi-key setups), but conflicting host-specific SSH settings may still need manual cleanup. If any Host github.com rules remain, merge them carefully.

You still need to add the copied public key to your GitHub account (**Settings -> SSH and GPG Keys -> New SSH Key**, selecting **Authentication & Signing Key**) before SSH authentication and automatic commit signing verification will work.

Git commit signing is configured out of the box using native SSH signing (`gpg.format = ssh`), providing verified commit badges on GitHub without requiring GPG or GPG agent dependencies.

### 4. Restart and Verify

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
