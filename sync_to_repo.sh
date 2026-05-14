#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FILES=(
  # WM / display
  .config/hypr
  .config/wlogout
  .config/swaync

  # Terminal / shell
  .config/kitty
  .config/fastfetch

  # Editor
  .config/nvim

  # Bar / widgets
  .config/quickshell
  .config/rofi

  # Theming
  .config/gtk-3.0
  .config/gtk-4.0
  .config/Kvantum
  .config/fontconfig
  .config/nwg-look
  .config/matugen

  # Apps
  .config/cava
  .config/lazygit
  .config/htop
  .config/pacseek
  .config/ohmyposh
  .config/tmux
  .config/yay
  .config/vesktop

  # Single files
  .bashrc
  .zshrc
  .gitconfig
  .config/starship.toml
  .config/libinput-gestures.conf
  .config/user-dirs.dirs
)

COPIED=0
SKIPPED=0

echo "Syncing live configs → repo..."
echo

for rel in "${FILES[@]}"; do
  src="$HOME/$rel"
  dst="$REPO_DIR/$rel"

  if [ ! -e "$src" ]; then
    echo "  SKIP  $rel  (not found at $src)"
    ((SKIPPED++)) || true
    continue
  fi

  mkdir -p "$(dirname "$dst")"

  if [ -d "$src" ]; then
    # Directory: rsync contents
    rsync -a --delete "$src/" "$dst/"
    echo "  DIR   $rel"
  else
    cp -p "$src" "$dst"
    echo "  FILE  $rel"
  fi
  ((COPIED++)) || true
done

echo
echo "Done. Copied: $COPIED  Skipped: $SKIPPED"
echo

# ── Optional: commit and push ─────────────────────────────────────────────────
cd "$REPO_DIR"

if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
  read -rp "Commit and push changes? [y/N] " answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    git add -A
    default_msg="dotfiles: sync $(date '+%Y-%m-%d %H:%M')"
    read -rp "Commit message [$default_msg]: " msg
    git commit -m "${msg:-$default_msg}"
    git push
    echo "Pushed."
  else
    echo "Changes staged in repo but not committed."
  fi
else
  echo "No changes detected in repo."
fi
