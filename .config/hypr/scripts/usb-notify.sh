#!/usr/bin/env bash
# usage: usb-notify.sh <added|removed>

set -u
SOUND_DIR=/usr/share/sounds/Yaru/stereo

action=""
devtype=""
model=""
vendor=""

flush() {
  [[ $devtype == usb_device ]] || return 0

  local name="${vendor:+$vendor }${model:-Unknown device}"
  name=${name//_/ }

  case $action in
  add)
    notify-send -a usb-notify -i drive-removable-media \
      "USB connected" "$name"
    pw-play "$SOUND_DIR/device-added.oga" &
    ;;
  remove)
    notify-send -a usb-notify -i drive-removable-media \
      "USB disconnected" "$name"
    pw-play "$SOUND_DIR/device-removed.oga" &
    ;;
  esac
}

udevadm monitor --udev --subsystem-match=usb --property |
  while IFS= read -r line; do
    if [[ -z $line ]]; then
      flush
      action=""
      devtype=""
      model=""
      vendor=""
      continue
    fi
    case $line in
    ACTION=*) action=${line#ACTION=} ;;
    DEVTYPE=*) devtype=${line#DEVTYPE=} ;;
    ID_MODEL=*) model=${line#ID_MODEL=} ;;
    ID_VENDOR=*) vendor=${line#ID_VENDOR=} ;;
    esac
  done
