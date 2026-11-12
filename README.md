# Dotfiles

Professional, minimalist, and high-performance development environment for Apple Silicon macOS.

## 🚀 Overview

This repository contains my personal configuration files for a streamlined developer experience.

- **Fish Shell**: Canonical daily-driver interactive login shell with auto-suggestions.
- **Zsh**: Second shell, configured with the same environment and aliases as fish (`.zshenv`, `.zshrc`).
- **Starship**: Lightning-fast, minimalist, and context-aware prompt.
- **Ghostty**: High-performance GPU-accelerated terminal emulator.
- **Git**: Advanced global configuration with professional defaults.
- **Claude Code**: Status line showing model, token counts, cost in USD, context usage, rate limits and the git branch (`~/.claude/statusline.sh`, requires `jq`). Only the `statusLine` key of `~/.claude/settings.json` is managed.
- **VS Code**: Optimized `settings.json` focused on productivity and clean UI.
- **Brewfile**: Automated management of all macOS applications and CLI tools.
- **Chezmoi**: Modern, secure, and declarative dotfiles management. Source files live in `home/`.
- **Nerd Fonts**: Curated developer fonts managed via Homebrew casks.

## 🛠️ Installation

### 1. Install Homebrew and Chezmoi

This repository targets Apple Silicon Macs only and assumes Homebrew is installed in `/opt/homebrew`.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
```

### 2. Clone the Repository

```bash
git clone https://github.com/burakkaygusuz/dotfiles.git ~/dotfiles
```

### 3. Apply the Dotfiles

```bash
chezmoi init --apply --source ~/dotfiles
```

Chezmoi asks for your Git email and for the names of secrets to read from the Keychain (space-separated, may be empty).
The apply step installs Homebrew packages from the Brewfile (including Nerd Fonts) and sets `fish` as the default login shell.
If `fish` is not registered in `/etc/shells`, you will be prompted for your password to add it.

Inspect or re-apply changes later with:

- `chezmoi diff` — Preview differences between this repo and your `$HOME` files.
- `chezmoi apply` — Apply dotfiles (Chezmoi prompts if a local file was modified).
- `chezmoi apply --force` — Force overwrite local changes with repo versions.

Python is managed by uv:

```bash
uv python install --default
```

### 4. Secrets (Optional)

Secrets live in the macOS Keychain under the service `dotfiles-env`.
Each name you list at `chezmoi init` is exported to both shells from `~/.config/shell/secrets.sh`.

```bash
chezmoi secret keyring set --service=dotfiles-env --user=NAME
```

To add or change names, run `chezmoi init --data=false --source ~/dotfiles`, answer the prompts again, then run `chezmoi apply`.
After the values are in the Keychain and the apply works, delete `~/.secrets.env`.

### 5. Bootstrap GitHub SSH (Optional)

The SSH bootstrap is intentionally separate from the apply step.
It creates an `ed25519` key if needed, loads it into the macOS keychain, and uploads it to GitHub for authentication and signing.
The script reads the email from `git config --global user.email`, so run `chezmoi apply` first.

```bash
~/dotfiles/ssh/setup-github-ssh.sh
```

The script logs you in to `gh` (browser flow) if needed, and adds the `admin:public_key` and `admin:ssh_signing_key` scopes. It is safe to re-run: keys GitHub already has are skipped.

Then apply again, so Chezmoi writes `~/.ssh/config`, `~/.ssh/allowed_signers` and the git signing settings:

```bash
chezmoi apply
```

Chezmoi owns `~/.ssh/config`. Put custom SSH rules in `home/private_dot_ssh/private_config`, not in the file on your machine.

Test the connection:

```bash
git ls-remote git@github.com:burakkaygusuz/dotfiles HEAD
```

Git commit signing uses native SSH signing (`gpg.format = ssh`), providing verified commit badges on GitHub without GPG.
Local `git log --show-signature` verification uses `~/.ssh/allowed_signers`.

### 6. Restart and Verify

After the steps above:

- Restart your terminal session so the default shell and prompt changes are applied cleanly.
- Open VS Code again if you want the updated terminal settings to take effect.
- If the apply prompted you for a password to change the shell, ensure it succeeded.

## 📦 Maintenance

### Update Brewfile

```bash
brew bundle dump --describe --force --file=~/dotfiles/Brewfile
```

### Cleanup packages not in Brewfile

```bash
brew bundle cleanup --file=~/dotfiles/Brewfile
```

This is a dry run that lists packages not in the Brewfile. Add `--force` only after reviewing the list.

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
