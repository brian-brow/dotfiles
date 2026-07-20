#!/bin/bash
# === CONFIG ===
CLASS="hypridle-screensaver"

# don't stack instances if already running
pgrep -f "kitty --class $CLASS" >/dev/null 2>&1 && exit 0

PIDS=()
COUNT=0
for MON in $(hyprctl monitors -j | jq -r '.[].name'); do
  hyprctl dispatch "hl.dsp.focus({ monitor = \"$MON\" })"
  kitty --class "$CLASS" -e cmatrix -abs &
  PIDS+=("$!")
  COUNT=$((COUNT + 1))

  # wait until this window has actually mapped before focusing the next monitor,
  # otherwise kitty's startup latency races the focus switch and they all land together
  for _ in $(seq 1 40); do
    N=$(hyprctl clients -j | jq -r --arg c "$CLASS" '[.[] | select(.class==$c)] | length')
    [ "$N" -ge "$COUNT" ] && break
    sleep 0.05
  done
done

# any single instance exiting (keypress) closes the rest together
wait -n
kill "${PIDS[@]}" 2>/dev/null
