#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Branch config ─────────────────────────────────────────────────────────────
CONFIG="$HOME/.dotfiles-config"

if [ ! -f "$CONFIG" ]; then
  echo "No dotfiles config found. Which setup is this machine?"
  echo "  1) desktop"
  echo "  2) laptop"
  read -rp "Choice [1/2]: " choice
  case "$choice" in
  1) BRANCH="desktop" ;;
  2) BRANCH="laptop" ;;
  *)
    echo "Invalid choice, defaulting to desktop"
    BRANCH="desktop"
    ;;
  esac
  echo "DOTFILES_BRANCH=\"$BRANCH\"" >"$CONFIG"
  echo "Saved to $CONFIG"
  echo
else
  source "$CONFIG"
  BRANCH="$DOTFILES_BRANCH"
fi

current="$(git -C "$REPO_DIR" branch --show-current)"
if [ "$current" != "$BRANCH" ]; then
  echo "Switching branch: $current → $BRANCH"
  git -C "$REPO_DIR" checkout "$BRANCH"
  echo
fi

# ─── Tracked files ────────────────────────────────────────────────────────────
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

  # Wallpapers
  Wallpapers
)

COPIED=0
SKIPPED=0

echo "Syncing live configs → repo ($BRANCH)..."
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
