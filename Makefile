SHELL := /bin/bash
DOTFILES_DIR := $(shell pwd)

.PHONY: all macos brew symlinks wrappers shell fonts help

help:
	@echo "Available commands:"
	@echo "  make all       - Run the full setup (brew, symlinks, wrappers, shell)"
	@echo "  make brew      - Install Homebrew and packages from Brewfile"
	@echo "  make symlinks  - Create symlinks for all configuration files"
	@echo "  make shell     - Set fish as the default shell"
	@echo "  make wrappers  - Set up command wrappers (find, grep)"
	@echo "  make fonts     - Install Nerd Fonts (runs fonts.sh)"

all: macos brew symlinks wrappers shell

macos:
	@echo "🍏 Checking for Apple Silicon..."
	@if [ "$$(uname -m)" != "arm64" ]; then \
		echo "Error: This repository supports Apple Silicon Macs only."; exit 1; \
	fi

brew: macos
	@echo "🍺 Installing Homebrew and packages..."
	@if ! command -v brew >/dev/null 2>&1; then \
		NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@eval "$$(/opt/homebrew/bin/brew shellenv)" && brew bundle --file=$(DOTFILES_DIR)/Brewfile

symlinks:
	@echo "🔗 Creating symlinks..."
	@mkdir -p $(HOME)/.config/fish $(HOME)/.config/ghostty "$(HOME)/Library/Application Support/Code/User"
	@ln -sfn $(DOTFILES_DIR)/fish/config.fish $(HOME)/.config/fish/config.fish
	@ln -sfn $(DOTFILES_DIR)/zsh/.zshrc $(HOME)/.zshrc
	@ln -sfn $(DOTFILES_DIR)/starship/starship.toml $(HOME)/.config/starship.toml
	@ln -sfn $(DOTFILES_DIR)/git/.gitconfig $(HOME)/.gitconfig
	@ln -sfn $(DOTFILES_DIR)/git/.gitignore_global $(HOME)/.gitignore_global
	@ln -sfn $(DOTFILES_DIR)/ghostty/config $(HOME)/.config/ghostty/config
	@ln -sfn $(DOTFILES_DIR)/vscode/settings.json "$(HOME)/Library/Application Support/Code/User/settings.json"
	@echo "✅ All symlinks created."

wrappers:
	@echo "⚡ Setting up command wrappers..."
	@mkdir -p $(HOME)/.local/bin
	@echo '#!/usr/bin/env bash' > $(HOME)/.local/bin/find
	@echo 'exec bfs "$$@"' >> $(HOME)/.local/bin/find
	@echo '#!/usr/bin/env bash' > $(HOME)/.local/bin/grep
	@echo 'exec ugrep "$$@"' >> $(HOME)/.local/bin/grep
	@chmod +x $(HOME)/.local/bin/find $(HOME)/.local/bin/grep

shell:
	@echo "🐚 Setting default shell to fish..."
	@if ! grep -qxF "$$(command -v fish)" /etc/shells; then \
		echo "$$(command -v fish)" | sudo tee -a /etc/shells; \
	fi
	@chsh -s "$$(command -v fish)"

fonts:
	@echo "🔤 Installing fonts..."
	@chmod +x $(DOTFILES_DIR)/fonts.sh
	@$(DOTFILES_DIR)/fonts.sh
