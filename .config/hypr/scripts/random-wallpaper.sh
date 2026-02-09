#!/bin/bash

WALLDIR="$HOME/Wallpapers"
CURRENT_WALLPAPER=$(readlink "$HOME/.config/hypr/current_wallpaper")

# wait for daemon to be ready
sleep 1

NEW_WALLPAPER="$(find "$WALLDIR" -type f ! -name "CURRENT_WALLPAPER" | shuf -n 1)"
swww img "$(find "$WALLDIR" -type f | shuf -n 1)" \
  --transition-type center \
  --transition-duration 1

