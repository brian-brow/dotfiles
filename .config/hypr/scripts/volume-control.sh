#!/usr/bin/env bash

set -euo pipefail

STEP=5
SINK='@DEFAULT_SINK@'
APP_NAME="system-volume"

get_volume() {
  pactl get-sink-volume "$SINK" | grep -Po '\d+(?=%)' | head -n 1
}

get_mute() {
  pactl get-sink-mute "$SINK" | awk '{print $2}'
}

clamp_volume() {
  local vol="$1"
  if [ "$vol" -gt 100 ]; then
    echo 100
  elif [ "$vol" -lt 0 ]; then
    echo 0
  else
    echo "$vol"
  fi
}

get_icon() {
  local vol="$1"
  local mute="$2"

  if [ "$mute" = "yes" ] || [ "$vol" -eq 0 ]; then
    echo "audio-volume-muted-symbolic"
  elif [ "$vol" -lt 34 ]; then
    echo "audio-volume-low-symbolic"
  elif [ "$vol" -lt 67 ]; then
    echo "audio-volume-medium-symbolic"
  else
    echo "audio-volume-high-symbolic"
  fi
}

send_notification() {
  local vol mute icon body
  vol="$(clamp_volume "$(get_volume)")"
  mute="$(get_mute)"
  icon="$(get_icon "$vol" "$mute")"

  if [ "$mute" = "yes" ]; then
    body="Muted"
  else
    body="${vol}%"
  fi

  notify-send \
    -a "$APP_NAME" \
    -u low \
    -i "$icon" \
    -h string:x-canonical-private-synchronous:volume \
    -h int:value:"$vol" \
    "Volume" \
    "$body"
}

case "${1:-}" in
up)
  pactl set-sink-mute "$SINK" 0
  pactl set-sink-volume "$SINK" "+${STEP}%"
  ;;
down)
  pactl set-sink-mute "$SINK" 0
  pactl set-sink-volume "$SINK" "-${STEP}%"
  ;;
mute)
  pactl set-sink-mute "$SINK" toggle
  ;;
*)
  echo "Usage: $0 {up|down|mute}"
  exit 1
  ;;
esac

send_notification
