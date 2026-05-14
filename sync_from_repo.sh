#!/usr/bin/env bash
set -euo pipefail

SCRIPT="$(readlink -f "${BASH_SOURCE[0]}")"
REPO_DIR="$(dirname "$SCRIPT")"

# ── New system bootstrap ───────────────────────────────────────────────────────
CONFIG="$HOME/.dotfiles-config"

if [ ! -f "$CONFIG" ]; then
  read -rp "New system? Run package install first? [y/N] " new_system
  if [[ "$new_system" =~ ^[Yy]$ ]]; then

    PACKAGES=(
      # System foundation
      base base-devel linux linux-headers linux-firmware amd-ucode
      grub os-prober efibootmgr dosfstools mtools
      sudo nano man-db git wget curl unzip zip rsync
      networkmanager iwd wpa_supplicant wireless_tools
      pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber
      gst-plugin-pipewire libpulse
      zram-generator

      # GPU — comment out whichever don't apply
      nvidia-open libva-nvidia-driver
      # lib32-opencl-nvidia  # uncomment if needed

      # Desktop environment
      hyprland hyprlock hyprpicker hyprpolkitagent uwsm
      sddm xdg-desktop-portal-hyprland xdg-utils
      qt5-wayland qt6-wayland qt6ct
      swaync dunst libnotify
      rofi
      polkit-kde-agent

      # Daily driver apps
      kitty neovim tmux lazygit
      fastfetch htop fzf bat tree jq yazi
      thunderbird mpv gimp
      obsidian

      # Theming
      kvantum nwg-look papirus-icon-theme
      ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-mononoki-nerd
      noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
      woff2-font-awesome gnome-themes-extra

      # Tools
      grim slurp wl-clipboard wf-recorder
      playerctl pavucontrol easyeffects cava
      bluetui bluez bluez-utils
      ddcutil piper
      docker docker-compose
      wireguard-tools openvpn networkmanager-openvpn
      smartmontools evtest
      7zip

      # Extra
      virt-manager libvirt dnsmasq qemu-desktop
      obs-studio

      # Wallpapers
      Wallpapers
    )

    AUR_PACKAGES=(
      yay
      quickshell-git
      zen-browser-bin
      vesktop
      matugen
      oh-my-posh
      wlogout
      claude-code
    )

    echo "Installing official packages..."
    sudo pacman -Syu --needed "${PACKAGES[@]}" || {
      echo "Some packages failed to install, continuing anyway..."
    }

    echo
    echo "Installing AUR packages..."
    if ! command -v yay &>/dev/null; then
      echo "yay not found, installing..."
      git clone https://aur.archlinux.org/yay.git /tmp/yay
      cd /tmp/yay
      makepkg -si --noconfirm
      cd "$REPO_DIR"
    fi
    yay -S --needed "${AUR_PACKAGES[@]}" || {
      echo "Some AUR packages failed to install, continuing anyway..."
    }

    echo
    echo "Packages installed."
    echo
  fi
fi

# ── Branch config ─────────────────────────────────────────────────────────────
if [ ! -f "$CONFIG" ]; then
  echo "Which setup is this machine?"
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
