#!/usr/bin/env bash

set -euo pipefail

STEP=5
APP_NAME="system-brightness"

get_brightness() {
  local current max
  current="$(brightnessctl get)"
  max="$(brightnessctl max)"
  echo $((current * 100 / max))
}

clamp_percent() {
  local val="$1"
  if [ "$val" -gt 100 ]; then
    echo 100
  elif [ "$val" -lt 0 ]; then
    echo 0
  else
    echo "$val"
  fi
}

get_icon() {
  local brightness="$1"

  if [ "$brightness" -lt 33 ]; then
    echo "display-brightness-low-symbolic"
  elif [ "$brightness" -lt 67 ]; then
    echo "display-brightness-medium-symbolic"
  else
    echo "display-brightness-high-symbolic"
  fi
}

send_notification() {
  local brightness icon
  brightness="$(clamp_percent "$(get_brightness)")"
  icon="$(get_icon "$brightness")"

  notify-send \
    -a "$APP_NAME" \
    -u low \
    -i "$icon" \
    -h string:x-canonical-private-synchronous:brightness \
    -h int:value:"$brightness" \
    "Brightness" \
    "${brightness}%"
}

case "${1:-}" in
up)
  brightnessctl -e4 -n2 set "${STEP}%+"
  ;;
down)
  brightnessctl -e4 -n2 set "${STEP}%-"
  ;;
*)
  echo "Usage: $0 {up|down}"
  exit 1
  ;;
esac

send_notification
