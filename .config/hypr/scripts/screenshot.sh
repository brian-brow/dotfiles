#!/bin/bash

FILE=~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png

grim -g "$(slurp)" "$FILE" && wl-copy --type image/png <"$FILE"
notify-send -i "$FILE" "Screenshot saved"
