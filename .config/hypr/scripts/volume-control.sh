#!/bin/bash

VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1)

case $1 in
up)
  pactl set-sink-volume @DEFAULT_SINK@ +5%
  ;;
down)
  pactl set-sink-volume @DEFAULT_SINK@ -5%
  ;;
mute)
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  ;;
esac

# Get current volume
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1)
MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )\w+')

if [ "$VOLUME" -gt 100 ]; then
  VOLUME=$(100)
fi

# Send notification
if [ "$MUTE" = "yes" ]; then
  notify-send -u low -h string:x-canonical-private-synchronous:volume "Volume" "Muted"
else
  notify-send -u low -h string:x-canonical-private-synchronous:volume "Volume" "$VOLUME%" -h int:value:$VOLUME
fi
