#!/usr/bin/env bash
# Mirrors modules/Memory.qml: current usage % plus a rolling 15-sample sparkline.
HIST_FILE="/tmp/waybar-mem-history"
GLYPHS=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

pct=$(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {printf "%d", (t-a)/t*100}' /proc/meminfo)

hist=$(cat "$HIST_FILE" 2>/dev/null)
hist="${hist} ${pct}"
hist=$(tr ' ' '\n' <<< "$hist" | grep -E '^[0-9]+$' | tail -15 | tr '\n' ' ')
echo "$hist" > "$HIST_FILE"

spark=""
for v in $hist; do
  level=$(( v * 7 / 100 ))
  (( level > 7 )) && level=7
  spark+="${GLYPHS[level]}"
done

# Memory.qml draws only a graph (no number), so emit the sparkline alone and
# keep the live percentage in the tooltip.
jq -nc --arg text "$spark" --arg tooltip "Memory: ${pct}%" '{text:$text, tooltip:$tooltip}'
