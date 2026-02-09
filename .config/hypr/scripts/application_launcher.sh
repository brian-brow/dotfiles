#!/bin/bash
pgrep rofi >/dev/null 2>&1 && killall rofi || rofi -show drun
