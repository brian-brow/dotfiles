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
)

COPIED=0
SKIPPED=0

# ── Optional: pull latest first ───────────────────────────────────────────────
cd "$REPO_DIR"
read -rp "Pull latest from remote ($BRANCH)? [Y/n] " pull_answer
if [[ ! "$pull_answer" =~ ^[Nn]$ ]]; then
  git pull
  echo
fi

echo "Applying repo configs → system ($BRANCH)..."
echo

for rel in "${FILES[@]}"; do
  src="$REPO_DIR/$rel"
  dst="$HOME/$rel"

  if [ ! -e "$src" ]; then
    echo "  SKIP  $rel  (not in repo)"
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
