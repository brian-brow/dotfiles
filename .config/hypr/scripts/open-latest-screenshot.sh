#!/usr/bin/env bash
latest=$(ls -t "$HOME/Pictures/Screenshots"/*.png 2>/dev/null | head -n1)
if [ -n "$latest" ]; then
  nemo "$latest"
fi
