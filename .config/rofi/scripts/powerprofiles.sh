#!/usr/bin/env bash
#
# Power profile picker using rofi + powerprofilesctl.
# Requires: rofi (wayland fork), power-profiles-daemon

set -euo pipefail

THEME="${HOME}/.config/rofi/powerprofiles.rasi"

pgrep rofi >/dev/null 2>&1 && killall rofi && exit 0

current="$(powerprofilesctl get 2>/dev/null || echo "balanced")"

declare -A profile_map=(
  ["Performance"]="performance"
  ["Balanced"]="balanced"
  ["Power Saver"]="power-saver"
)

menu=""
for label in "Performance" "Balanced" "Power Saver"; do
  key="${profile_map[$label]}"
  if [[ "$key" == "$current" ]]; then
    menu+="${label} ●\n"
  else
    menu+="${label}\n"
  fi
done

chosen="$(echo -e "${menu%\\n}" | rofi -dmenu -p "Power Profile" -theme "$THEME")"

# Match by checking which label is contained in the chosen line,
# rather than trying to strip the marker positionally.
selected_key=""
for label in "Performance" "Balanced" "Power Saver"; do
  if [[ "$chosen" == *"$label"* ]]; then
    selected_key="${profile_map[$label]}"
    break
  fi
done

if [[ -n "$selected_key" ]]; then
  powerprofilesctl set "$selected_key"
fi
