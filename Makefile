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
	@echo "🔗 Creating symlinks using GNU Stow..."
	@mkdir -p $(HOME)/.config/fish $(HOME)/.config/ghostty "$(HOME)/Library/Application Support/Code/User"
	@if ! command -v stow >/dev/null 2>&1; then \
		echo "Error: GNU Stow is not installed. Run 'make brew' first."; exit 1; \
	fi
	@stow --dir=$(DOTFILES_DIR) --target=$(HOME) --no-folding -R fish zsh starship git ghostty vscode
	@echo "✅ All symlinks created with Stow."

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
