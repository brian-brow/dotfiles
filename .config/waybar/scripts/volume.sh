#!/usr/bin/env bash
# Mirrors modules/VolumeIndicator.qml: muted / bluetooth / normal icon states.
line=$(wpctl get-volume @DEFAULT_SINK@ 2>/dev/null)
vol=$(awk '{print $2}' <<< "$line")
pct=$(awk -v v="${vol:-0}" 'BEGIN{printf "%d", v*100}')

muted=0
grep -qi MUTED <<< "$line" && muted=1

default_sink=$(pactl get-default-sink 2>/dev/null)
is_bt=0
grep -qi bluez <<< "$default_sink" && is_bt=1

if (( muted )); then
  icon=$'\U000f075f'
  cls="muted"
elif (( is_bt )); then
  icon=$''
  cls="bluetooth"
else
  icon=$''
  cls="normal"
fi

jq -nc --arg text "${icon} ${pct}%" --arg tooltip "Volume: ${pct}%" --arg cls "$cls" \
  '{text:$text, tooltip:$tooltip, class:$cls}'
