#!/bin/bash
export YDOTOOL_SOCKET=/tmp/.ydotool_socket

echo "Autoclicker will start in 3 seconds..."
echo "Position your mouse and press Ctrl+C to stop"
sleep 3

while true; do
		echo "click"
    ydotool click 0xC0
    sleep 0.003  # Click every 0.5 seconds (slower for testing)
done
