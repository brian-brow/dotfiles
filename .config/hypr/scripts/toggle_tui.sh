#!/usr/bin/env bash
# Usage: toggle-tui.sh <program> [args...]
prog="$1"
shift

if [ -z "$prog" ]; then
  echo "Usage: toggle-tui.sh <program> [args...]" >&2
  exit 1
fi

class="${prog}-floating"

win_addr=$(hyprctl clients -j | jq -r --arg class "$class" '.[] | select(.class == $class) | .address' | head -n1)

if [ -n "$win_addr" ]; then
  hyprctl dispatch 'hl.dsp.window.close({ window = "address:'"$win_addr"'" })'
else
  kitty --class "$class" -o confirm_os_window_close=0 "$prog" "$@" &
  disown
fi
