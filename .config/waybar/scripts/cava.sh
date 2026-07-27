#!/usr/bin/env bash
# Mirrors modules/CavaView.qml + CavaSource.qml (40-bar raw cava feed,
# resampled to fit), with the clock spliced into the center so the time
# is always legible on top of the waveform instead of a separate module.
BAR_COLOR="#a8c8ff"
CLOCK_FG="#e1e2e9"
CLOCK_BG="#1d2024"
BARS_TOTAL=26
GLYPHS=(" " "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

cava | while IFS= read -r line; do
  IFS=';' read -ra vals <<< "$line"
  n=${#vals[@]}
  (( n == 0 )) && continue
  step=$(( n / BARS_TOTAL ))
  (( step < 1 )) && step=1

  bars=()
  for (( i = 0; i < BARS_TOTAL; i++ )); do
    idx=$(( i * step ))
    (( idx >= n )) && idx=$(( n - 1 ))
    v=${vals[idx]:-0}
    [[ "$v" =~ ^[0-9]+$ ]] || v=0
    level=$(( v * 8 / 100 ))
    (( level > 8 )) && level=8
    bars[i]="${GLYPHS[level]}"
  done

  clock=" $(date +'%I:%M %p') "
  clock_len=${#clock}
  left_count=$(( (BARS_TOTAL - clock_len) / 2 ))
  (( left_count < 0 )) && left_count=0
  right_start=$(( left_count + clock_len ))

  left=""
  for (( i = 0; i < left_count; i++ )); do left+="${bars[i]}"; done
  right=""
  for (( i = right_start; i < BARS_TOTAL; i++ )); do right+="${bars[i]}"; done

  # Exit quietly if waybar has closed the pipe (e.g. on reload) instead of
  # spamming "write error: Broken pipe" into the log.
  printf "<span color='%s'>%s</span><span color='%s' background='%s' weight='bold'>%s</span><span color='%s'>%s</span>\n" \
    "$BAR_COLOR" "$left" "$CLOCK_FG" "$CLOCK_BG" "$clock" "$BAR_COLOR" "$right" 2>/dev/null || break
done
