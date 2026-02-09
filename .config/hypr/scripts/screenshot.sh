#!/bin/bash
grim - | tee >(wl-copy) > ~/.config/hypr/screenshot.png
notify-send -i ~/.config/hypr/screenshot.png "Screenshot Taken"
