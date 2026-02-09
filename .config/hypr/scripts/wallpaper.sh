##!/bin/bash
# === CONFIG ===
WALLPAPER_DIR="$HOME/Wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"
CUSTOM_SCRIPT="$HOME/.config/hypr/scripts/random-wallpaper.sh"
PREVIEW_DEST="$HOME/.config/rofi/imagebox.png"
SCREEN_WIDTH=1920
SCREEN_HEIGHT=1080

cd "$WALLPAPER_DIR" || exit 1

# === handle spaces name
IFS=$'\n'

# === ICON-PREVIEW SELECTION WITH ROFI, SORTED BY NEWEST ===
SELECTED_WALL=$(for a in $(
  echo "󰝮 Random Wallpaper"
  ls -t *.jpg *.png *.gif *.jpeg 2>/dev/null
); do echo -en "$a\0icon\x1f$a\n"; done | rofi -dmenu -p "")

[ -z "$SELECTED_WALL" ] && exit 1

echo "$SELECTED_PATH"

if [ "$SELECTED_WALL" = "󰝮 Random Wallpaper" ]; then
  SELECTED_PATH="$(find "$WALLPAPER_DIR" -type f ! -wholename "$(readlink "$SYMLINK_PATH")" | shuf -n 1)"
else
  SELECTED_PATH="$WALLPAPER_DIR/$SELECTED_WALL"
fi

RANDOM_X=$((RANDOM % SCREEN_WIDTH))
RANDOM_Y=$((RANDOM % SCREEN_HEIGHT))

# === SET WALLPAPER ===
swww img "$SELECTED_PATH" --transition-type outer --transition-duration 2 --transition-pos "$RANDOM_X,$RANDOM_Y"

# === GENERATE COLORS WITH MATUGEN ===
matugen image "$SELECTED_PATH" --mode dark

# === CREATE SYMLINK ===
mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"

# pgrep rofi >/dev/null 2>&1 && killall rofi || rofi -show drun
