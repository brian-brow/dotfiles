#!/usr/bin/env bash
set -euo pipefail

OUTDIR="$HOME/Videos/screen-recordings"
mkdir -p "$OUTDIR"

if pgrep -x wf-recorder >/dev/null; then
  pkill -INT wf-recorder
  notify-send "Screen recording stopped" "Saved to $OUTDIR"
  exit 0
fi

region="$(slurp || true)"
if [ -z "$region" ]; then
  hyprctl monitors | awk '/Monitor/ {getline; print $1","$2" "$3}'
fi

outfile="$OUTDIR/$(date +%F_%H-%M-%S).mp4"

notify-send "Screen recording started" "$outfile"
wf-recorder -g "$region" -f "$outfile"
