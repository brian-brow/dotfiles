#!/bin/bash
WALLPAPER_DIR="$HOME/Wallpapers"
PREVIEW_DEST="$HOME/.config/rofi/imagebox.png"

# Skip the random option
if [ "$1" = "󰝮 Random Wallpaper" ]; then
  exit 0
fi

# Copy the hovered wallpaper
cp "$WALLPAPER_DIR/$1" "$PREVIEW_DEST" 2>/dev/null

# Force rofi to reload (might flicker)
pkill -USR1 rofi
