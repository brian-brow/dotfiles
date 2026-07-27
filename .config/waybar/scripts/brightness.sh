#!/usr/bin/env bash
# Mirrors modules/BrightnessIndicator.qml icon thresholds.
b=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
[[ "$b" =~ ^[0-9]+$ ]] || b=0

if (( b < 33 )); then icon=$'\U000f00de'
elif (( b < 66 )); then icon=$'\U000f00df'
else icon=$'\U000f00e0'
fi

jq -nc --arg text "${icon} ${b}%" --arg tooltip "Brightness: ${b}%" '{text:$text, tooltip:$tooltip}'
