#!/usr/bin/env bash
# Usage: toggle-tui.sh <program> [args...]
prog="$1"
shift

if [ -z "$prog" ]; then
  echo "Usage: toggle-tui.sh <program> [args...]" >&2
  exit 1
fi

class="com.brian.${prog}.floating"

win_addr=$(hyprctl clients -j | jq -r --arg class "$class" '.[] | select(.class == $class) | .address' | head -n1)

if [ -n "$win_addr" ]; then
  hyprctl dispatch 'hl.dsp.window.close({ window = "address:'"$win_addr"'" })'
else
  if [ "$prog" = "nmtui" ]; then
    export NEWT_COLORS='root=black,black;window=black,black;border=white,black;title=cyan,black;button=white,black;actbutton=black,cyan;label=white,black;listbox=white,black;actlistbox=black,cyan'
  fi

  ghostty --class="$class" --confirm-close-surface=false -e "$prog" "$@" &
  disown
fi
