#!/usr/bin/env bash

# Paths
SAFE_FILE="$HOME/.config/ohmyposh/colors.json"
UNSAFE_FILE="$HOME/.config/matugen/templates/ohmyposh-unsafe.json"
OUTPUT_FILE="$HOME/.config/ohmyposh/brian.omp.json"

# Check files exist
if [[ ! -f "$SAFE_FILE" ]]; then
    echo "Safe file not found: $SAFE_FILE"
    exit 1
fi

if [[ ! -f "$UNSAFE_FILE" ]]; then
    echo "Unsafe file not found: $UNSAFE_FILE"
    exit 1
fi

cat "$SAFE_FILE" "$UNSAFE_FILE"

# Simply concatenate files
cat "$SAFE_FILE" "$UNSAFE_FILE" > "$OUTPUT_FILE"

cat "$OUTPUT_FILE"

echo "Generated Oh My Posh theme at $OUTPUT_FILE"

# Optional: reload shell prompt (Bash example)
if command -v oh-my-posh >/dev/null 2>&1; then
    eval "$(oh-my-posh init bash --config $OUTPUT_FILE)"
fi
