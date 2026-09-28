#!/bin/bash

# Emits one clipboard entry as JSON on stdout: a bare string for text, or
# {"image":"<path>"} for an image saved into the image store. In watch mode
# wl-paste invokes this with the payload on stdin and the mime as $1; without
# arguments it snapshots the current selection itself.

set -o pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/quickshell"
IMAGE_DIR="$STATE_DIR/clipboard-images"

[[ ${CLIPBOARD_STATE:-} == "sensitive" ]] && exit 0
types=$(wl-paste --list-types 2>/dev/null)
grep -qx 'x-kde-passwordManagerHint' <<<"$types" && exit 0

# Content-addressed, so copying the same image twice reuses the one file.
emit_image() {
  local tmp hash file
  mkdir -p "$IMAGE_DIR"
  tmp=$(mktemp --tmpdir="$IMAGE_DIR" clipboard.XXXXXX) || return 0
  cat >"$tmp"
  if [[ ! -s $tmp ]]; then
    rm -f "$tmp"
    return 0
  fi

  hash=$(sha256sum "$tmp" | awk '{print $1}')
  file="$IMAGE_DIR/$hash.png"
  if [[ -e $file ]]; then rm -f "$tmp"; else mv "$tmp" "$file"; fi

  jq -cn --arg path "$file" '{image: $path}'
}

case "${1:-}" in
image/png)
  emit_image
  ;;
text)
  # When an image is on the clipboard the image is the content — the text
  # flavor next to it is just the browser's HTML wrapper for the same thing.
  if grep -qx 'image/png' <<<"$types"; then cat >/dev/null; else jq -Rs .; fi
  ;;
*)
  if grep -qx 'image/png' <<<"$types"; then
    wl-paste --type image/png 2>/dev/null | emit_image
  else
    wl-paste --type text --no-newline 2>/dev/null | jq -Rs .
  fi
  ;;
esac
