SHELL := /bin/bash
DOTFILES_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
export PATH := /opt/homebrew/bin:$(PATH)

.PHONY: all macos brew symlinks symlinks-force diff shell verify-ssh help

help:
	@echo "Available commands:"
	@echo "  make all             - Run the full setup (brew, symlinks, shell)"
	@echo "  make brew            - Install Homebrew and packages from Brewfile"
	@echo "  make diff            - Show differences before applying dotfiles"
	@echo "  make symlinks        - Safely apply dotfiles with Chezmoi (prompts on conflict)"
	@echo "  make symlinks-force  - Force apply dotfiles with Chezmoi (overwrites conflicts)"
	@echo "  make shell           - Set fish as the default shell"
	@echo "  make verify-ssh      - Verify GitHub SSH configuration and connection"

all: macos brew symlinks shell

macos:
	@echo "🍏 Checking for Apple Silicon..."
	@if [ "$$(uname -s)" != "Darwin" ] || [ "$$(uname -m)" != "arm64" ]; then \
		echo "Error: This repository supports Apple Silicon Macs only."; exit 1; \
	fi

brew: macos
	@echo "🍺 Installing Homebrew and packages..."
	@if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ]; then \
		NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@/opt/homebrew/bin/brew bundle --file=$(DOTFILES_DIR)/Brewfile

diff:
	@echo "🔍 Checking dotfiles diff with Chezmoi..."
	@if ! command -v chezmoi >/dev/null 2>&1; then \
		echo "Error: Chezmoi is not installed. Run 'make brew' first."; exit 1; \
	fi
	@chezmoi diff --source $(DOTFILES_DIR)

symlinks:
	@echo "🔗 Applying dotfiles with Chezmoi..."
	@if ! command -v chezmoi >/dev/null 2>&1; then \
		echo "Error: Chezmoi is not installed. Run 'make brew' first."; exit 1; \
	fi
	@chezmoi apply --source $(DOTFILES_DIR)
	@echo "✅ All dotfiles applied successfully with Chezmoi."

symlinks-force:
	@echo "⚠️ Force applying dotfiles with Chezmoi..."
	@if ! command -v chezmoi >/dev/null 2>&1; then \
		echo "Error: Chezmoi is not installed. Run 'make brew' first."; exit 1; \
	fi
	@chezmoi apply --source $(DOTFILES_DIR) --force
	@echo "✅ All dotfiles force applied successfully with Chezmoi."

shell:
	@echo "🐚 Setting default shell to fish..."
	@FISH_PATH=$$(command -v fish || true); \
	if [ -z "$$FISH_PATH" ]; then \
		echo "Error: fish is not installed. Run 'make brew' first." >&2; exit 1; \
	fi; \
	if ! grep -qxF "$$FISH_PATH" /etc/shells; then \
		echo "$$FISH_PATH" | sudo tee -a /etc/shells; \
	fi; \
	if [ "$$(dscl . -read /Users/$$USER UserShell 2>/dev/null | awk '{print $$2}')" != "$$FISH_PATH" ]; then \
		chsh -s "$$FISH_PATH"; \
	fi

verify-ssh:
	@echo "🔍 Inspecting effective SSH config for github.com..."
	@ssh -G git@github.com | grep -E '^(hostname|user|identityfile|identitiesonly)' || true
	@echo "🔑 Testing GitHub SSH authentication..."
	@ssh -T git@github.com || true
