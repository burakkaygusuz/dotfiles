#!/usr/bin/env bash

# Custom Nerd Fonts Installer
# Direct download from GitHub releases to ~/Library/Fonts

set -euo pipefail

FONTS=(
    "CommitMono"
    "IBMPlexMono" # BlexMono is the Nerd Font name for IBM Plex Mono
    "FiraCode"
    "GeistMono"
    "Meslo"       # MesloLGS base
    "JetBrainsMono"
)

VERSION="${VERSION:-v3.4.0}" # Nerd Fonts version
FONT_DIR="${FONT_DIR:-$HOME/Library/Fonts}"
MAX_PARALLEL="${MAX_PARALLEL:-3}"

echo "Starting Nerd Fonts installation..."

mkdir -p "$FONT_DIR"

font_installed() {
    local font="$1"
    find "$FONT_DIR" -type f \( -iname "*${font}*.ttf" -o -iname "*${font}*.otf" \) -print -quit | grep -q .
}

install_font() {
    local font="$1"
    local url
    local temp_dir

    echo "installing $font..."
    url="https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/$font.zip"
    temp_dir="$(mktemp -d)"

    curl -fLo "$temp_dir/$font.zip" "$url"
    unzip -q "$temp_dir/$font.zip" -d "$temp_dir"

    find "$temp_dir" -name "*.[ot]tf" -exec cp {} "$FONT_DIR/" \;

    rm -rf "$temp_dir"
    echo "$font installed successfully."
}

wait_for_slot() {
    local running_jobs

    while true; do
        running_jobs="$(jobs -pr | wc -l | tr -d ' ')"
        if [ "$running_jobs" -lt "$MAX_PARALLEL" ]; then
            return 0
        fi

        sleep 0.1
    done
}

refresh_font_cache() {
    if command -v atsutil >/dev/null 2>&1; then
        echo "Refreshing user font cache..."
        atsutil databases -removeUser >/dev/null
    fi
}

pending_fonts=()
for font in "${FONTS[@]}"; do
    if font_installed "$font"; then
        echo "skipping $font (already installed)"
        continue
    fi

    pending_fonts+=("$font")
done

if [ "${#pending_fonts[@]}" -eq 0 ]; then
    echo "All requested fonts are already installed."
    exit 0
fi

pids=()
pid_fonts=()
for font in "${pending_fonts[@]}"; do
    wait_for_slot
    install_font "$font" &
    pids+=("$!")
    pid_fonts+=("$font")
done

for i in "${!pids[@]}"; do
    if ! wait "${pids[$i]}"; then
        echo "installation failed for ${pid_fonts[$i]}" >&2
        exit 1
    fi
done

refresh_font_cache

echo "Font installation completed!"
