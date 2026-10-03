#!/usr/bin/env bash
set -euo pipefail

SCRIPT="$(readlink -f "${BASH_SOURCE[0]}")"
REPO_DIR="$(dirname "$SCRIPT")"

# ── Branch config ─────────────────────────────────────────────────────────────
CONFIG="$HOME/.dotfiles-config"

if [ ! -f "$CONFIG" ]; then
  echo "No dotfiles config found. Which setup is this machine?"
  echo "  1) Arch desktop (desktop branch)"
  echo "  2) Arch laptop (arch-laptop branch)"
  echo "  3) Ubuntu laptop (ubuntu-desktop branch)"
  read -rp "Choice [1/2/3]: " choice
  case "$choice" in
  1) BRANCH="desktop" ;;
  2) BRANCH="arch-laptop" ;;
  3) BRANCH="ubuntu-desktop" ;;
  *)
    echo "Invalid choice" >&2
    exit 1
    ;;
  esac
else
  source "$CONFIG"
  BRANCH="${DOTFILES_BRANCH:-}"
fi

case "$BRANCH" in
desktop|arch-laptop|ubuntu-desktop) ;;
*) echo "Unknown branch in $CONFIG: $BRANCH" >&2; exit 1 ;;
esac

current="$(git -C "$REPO_DIR" branch --show-current)"
if [ "$current" != "$BRANCH" ]; then
  echo "This machine uses $BRANCH, but the checked-out branch is ${current:-detached}. Select $BRANCH in lazygit first." >&2
  exit 1
fi

if [ ! -f "$CONFIG" ]; then
  echo "DOTFILES_BRANCH=\"$BRANCH\"" >"$CONFIG"
  echo "Saved to $CONFIG"
fi

source "$REPO_DIR/sync_files.sh"

COPIED=0
SKIPPED=0

echo "Previewing live configs → repo ($BRANCH)..."
echo

for rel in "${FILES[@]}"; do
  src="$HOME/$rel"
  dst="$REPO_DIR/$rel"

  if [ ! -e "$src" ]; then
    echo "  SKIP  $rel  (not found at $src)"
    ((SKIPPED++)) || true
    continue
  fi

  echo "  $rel"
  if [ -d "$src" ]; then
    rsync -ani --mkpath --delete "$src/" "$dst/"
  else
    rsync -ani --mkpath "$src" "$dst"
  fi
done

echo
read -rp "Apply these changes, including deletions? [y/N] " answer
if [[ ! "$answer" =~ ^[Yy]$ ]]; then
  echo "No changes applied."
  exit 0
fi

for rel in "${FILES[@]}"; do
  src="$HOME/$rel"
  dst="$REPO_DIR/$rel"

  if [ ! -e "$src" ]; then
    continue
  fi

  if [ -d "$src" ]; then
    rsync -a --mkpath --delete "$src/" "$dst/"
  else
    rsync -a --mkpath "$src" "$dst"
  fi
  ((COPIED++)) || true
done

echo
echo "Done. Copied: $COPIED  Skipped: $SKIPPED"
