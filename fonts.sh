#!/bin/bash

# Custom Nerd Fonts Installer
# Direct download from GitHub releases to ~/Library/Fonts

set -e

FONTS=(
    "CommitMono"
    "IBMPlexMono" # BlexMono is the Nerd Font name for IBM Plex Mono
    "FiraCode"
    "GeistMono"
    "Meslo"       # MesloLGS base
    "JetBrainsMono"
)

VERSION="v3.4.0" # Latest Nerd Fonts version
FONT_DIR="$HOME/Library/Fonts"

echo "Starting Nerd Fonts installation..."

mkdir -p "$FONT_DIR"

for FONT in "${FONTS[@]}"; do
    if ls "$FONT_DIR" | grep -iq "$FONT"; then
        echo "skipping $FONT (already installed)"
        continue
    fi

    echo "installing $FONT..."
    URL="https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/$FONT.zip"
    TEMP_DIR=$(mktemp -d)

    curl -fLo "$TEMP_DIR/$FONT.zip" "$URL"
    unzip -q "$TEMP_DIR/$FONT.zip" -d "$TEMP_DIR"
    
    # Move only .ttf and .otf files
    find "$TEMP_DIR" -name "*.[ot]tf" -exec cp {} "$FONT_DIR/" \;
    
    rm -rf "$TEMP_DIR"
    echo "$FONT installed successfully."
done

echo "Font installation completed!"
