#!/usr/bin/env bash
# Mirrors modules/Network.qml parsing + icon thresholds exactly.
active=$(nmcli -t -f NAME,TYPE connection show --active | head -n 1)
wifi=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep '^yes')

conn_name=""
conn_type=""
signal=0
connected=0

if [[ -n "$active" ]]; then
  conn_name=$(cut -d: -f1 <<< "$active")
  conn_type=$(cut -d: -f2 <<< "$active")
  connected=1
fi

if [[ -n "$wifi" ]]; then
  conn_name=$(cut -d: -f2 <<< "$wifi")
  signal=$(cut -d: -f3 <<< "$wifi")
  [[ "$signal" =~ ^[0-9]+$ ]] || signal=0
fi

if (( ! connected )); then
  icon=$'\U000f05aa'
elif [[ "$conn_type" == *ethernet* ]]; then
  icon=$'\U000f0200'
elif (( signal < 25 )); then
  icon=$'\U000f091f'
elif (( signal < 50 )); then
  icon=$'\U000f0922'
elif (( signal < 75 )); then
  icon=$'\U000f0925'
else
  icon=$'\U000f0928'
fi

if (( connected )); then cls="connected"; else cls="disconnected"; fi

jq -nc --arg text "$icon" --arg tooltip "${conn_name:-Disconnected}" --arg cls "$cls" \
  '{text:$text, tooltip:$tooltip, class:$cls}'
