#!/usr/bin/env bash
# herdr port of ~/scripts/t and ~/scripts/tc.
# Usage: h [root]     (default ~/projects; `h ~/.config` replaces tc)

set -euo pipefail

root="${1:-$HOME/projects}"
root="${root%/}"

selected=$(find "$root" -mindepth 1 -maxdepth 1 -type d -printf '%P\n' | sort | fzf) || exit 0
[[ -n $selected ]] || exit 0

full_path="$root/$selected"
label="${selected//\//-}"

# tmux's new-session started a server implicitly; herdr's socket commands will
# not. Start one in the background and wait for the socket to come up.
if ! herdr status server >/dev/null 2>&1; then
  herdr server >/dev/null 2>&1 &
  for _ in {1..30}; do
    herdr status server >/dev/null 2>&1 && break
    sleep 0.1
  done
  if ! herdr status server >/dev/null 2>&1; then
    echo "h: could not start herdr server, falling back to plain launch" >&2
    exec herdr
  fi
fi

# tmux has-session equivalent. Labels are NOT unique in herdr, so take the
# first match rather than assuming there is exactly one.
existing=$(herdr workspace list \
  | jq -r --arg l "$label" 'first(.result.workspaces[] | select(.label == $l) | .workspace_id) // empty')

if [[ -n $existing ]]; then
  herdr workspace focus "$existing" >/dev/null
else
  herdr workspace create --cwd "$full_path" --label "$label" --focus >/dev/null
fi

# The calls above only move the server's focus. tmux attach-session also
# attached a client; herdr splits those, so attach here unless we are already
# inside a herdr pane (HERDR_ENV is herdr's $TMUX).
[[ -n ${HERDR_ENV:-} ]] || exec herdr
