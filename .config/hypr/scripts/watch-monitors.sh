#!/bin/bash
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock |
  while read -r line; do
    case "$line" in
    monitorremoved*)
      clients=$(hyprctl clients -j | jq -r '.[] | "\(.workspace.id)|\(.address)"')
      while IFS='|' read -r workspace address; do
        if ((workspace > 5)); then
          hyprctl dispatch 'hl.dsp.window.move({ workspace = 5, window = "address:'"$address"'" })'
        fi
      done <<<"$clients"
      ;;
    esac
  done
