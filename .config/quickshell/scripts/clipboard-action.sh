#!/bin/bash

# Copies entry <index> of the clipboard history, then pastes it into whatever
# window has focus.
#
# Text entries are read back out of the history file rather than passed in as
# an argument, so the full text survives even though the picker only ever
# renders a truncated preview of it.

set -o pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/quickshell"
HISTORY_FILE="$STATE_DIR/clipboard-history.json"

index="${1:-}"
[[ $index =~ ^[0-9]+$ && -r $HISTORY_FILE ]] || exit 1

if [[ $(jq -r --argjson i "$index" '.[$i] | type' "$HISTORY_FILE" 2>/dev/null) == object ]]; then
  path=$(jq -r --argjson i "$index" '.[$i].image // empty' "$HISTORY_FILE")
  [[ -r $path ]] || exit 1
  wl-copy --type image/png <"$path"
else
  text=$(jq -j --argjson i "$index" '.[$i] // empty' "$HISTORY_FILE" 2>/dev/null)
  [[ -n $text ]] || exit 1
  printf '%s' "$text" | wl-copy
fi

# The picker holds keyboard focus until it hides, and the compositor takes a
# moment to hand focus back to the window underneath. Sending the shortcut any
# sooner just types into a window that is on its way out.
sleep 0.2
hyprctl dispatch \
  'hl.dsp.send_shortcut({ mods = "SHIFT", key = "insert" })' >/dev/null
