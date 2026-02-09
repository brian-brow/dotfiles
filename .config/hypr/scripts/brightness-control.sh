#!/bin/bash

# Get current brightness as percentage (calculate manually)
CURRENT=$(brightnessctl get)
MAX=$(brightnessctl max)
BRIGHTNESS=$((CURRENT * 100 / MAX))

case $1 in
up)
  if [ "$BRIGHTNESS" -lt 100 ]; then
    brightnessctl -e4 -n2 set 5%+
  fi
  ;;
down)
  brightnessctl -e4 -n2 set 5%-
  ;;
esac

# Get updated brightness as percentage
CURRENT=$(brightnessctl get)
MAX=$(brightnessctl max)
BRIGHTNESS=$((CURRENT * 100 / MAX))

# Cap at 100 if needed
if [ "$BRIGHTNESS" -gt 100 ]; then
  BRIGHTNESS=100
fi

# Send notification
notify-send -u low -h string:x-canonical-private-synchronous:brightness "Brightness" "$BRIGHTNESS%" -h int:value:$BRIGHTNESS
