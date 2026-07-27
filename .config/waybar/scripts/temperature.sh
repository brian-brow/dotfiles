#!/usr/bin/env bash
# Mirrors modules/Temp.qml thresholds and coloring exactly.
t=$(awk '{print int($1/1000)}' /sys/class/thermal/thermal_zone0/temp)

if (( t < 40 )); then cls="cool"
elif (( t < 65 )); then cls="warm"
elif (( t < 80 )); then cls="hot"
else cls="critical"
fi

jq -nc --arg text "${t}" --arg tooltip "CPU Temp: ${t}°C" --arg cls "$cls" \
  '{text:$text, tooltip:$tooltip, class:$cls}'
