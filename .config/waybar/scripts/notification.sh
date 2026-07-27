#!/usr/bin/env bash
# Mirrors modules/Notification.qml class -> icon mapping exactly.
# swaync-client -swb is a persistent subscription (waybar-ready JSON stream),
# so this script must stay running and re-emit one line per update.
swaync-client -swb 2>/dev/null | while IFS= read -r raw; do
  cls=$(jq -r '.class // ""' <<< "$raw" 2>/dev/null)

  case "$cls" in
    dnd-inhibited-none|inhibited-none)
      icon=$'\U000f009b' ;;
    dnd-inhibited-notification|inhibited-notification)
      icon=$'\U000f009b' ;;
    dnd-notification)
      icon=$'\U000f0178' ;;
    dnd-none)
      icon=$'\U000f009c' ;;
    notification)
      icon=$'\U000f116b' ;;
    *)
      icon=$'\U000f009a' ;;
  esac

  tooltip=$(jq -r '.tooltip // ""' <<< "$raw" 2>/dev/null)
  jq -nc --arg text "$icon" --arg tooltip "$tooltip" --arg cls "$cls" \
    '{text:$text, tooltip:$tooltip, class:$cls}'
done
