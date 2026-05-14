#!/usr/bin/env bash

last_state="standard"

BAT_PATH="/sys/class/power_supply/BAT0"
APP_NAME="system-battery"

send_notification() {
  local urgency="$1"
  local icon="$2"
  local title="$3"
  local body="$4"
  local value="$5"
  local timeout="$6"

  notify-send \
    -a "$APP_NAME" \
    -u "$urgency" \
    -i "$icon" \
    -t "$timeout" \
    -h string:x-canonical-private-synchronous:battery \
    -h int:value:"$value" \
    "$title" \
    "$body"
}

while true; do
  battery=$(cat "$BAT_PATH/capacity")
  status=$(cat "$BAT_PATH/status")

  if [[ "$status" == "Charging" ]]; then
    new_state="standard"
  elif [[ "$battery" -le 5 ]]; then
    new_state="critical"
  elif [[ "$battery" -le 10 ]]; then
    new_state="very_low"
  elif [[ "$battery" -le 15 ]]; then
    new_state="low"
  else
    new_state="standard"
  fi

  if [[ "$status" != "Charging" && "$new_state" != "$last_state" ]]; then
    case "$new_state" in
    low)
      send_notification \
        "normal" \
        "battery-low-symbolic" \
        "Battery low" \
        "Battery at ${battery}%. Plug in soon." \
        "$battery" \
        4000
      ;;
    very_low)
      send_notification \
        "normal" \
        "battery-caution-symbolic" \
        "Battery very low" \
        "Battery at ${battery}%. Connect your charger now." \
        "$battery" \
        6000
      ;;
    critical)
      send_notification \
        "critical" \
        "battery-empty-symbolic" \
        "Critical battery" \
        "Battery at ${battery}%. Plug in immediately." \
        "$battery" \
        8000
      ;;
    esac
  fi

  last_state="$new_state"
  sleep 30
done
