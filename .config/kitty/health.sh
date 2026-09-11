#!/bin/sh
# Check that the upstream kitty install is wired up correctly.
# See README.md in this directory.

APP="$HOME/.local/kitty.app"
SESSION_PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
fail=0

ok()   { printf '  \033[32mOK\033[m    %s\n' "$1"; }
bad()  { printf '  \033[31mFAIL\033[m  %s\n' "$1"; fail=1; }
note() { printf '        %s\n' "$1"; }

echo
echo "install"
if [ -x "$APP/bin/kitty" ]; then
    ok "$APP  ($("$APP/bin/kitty" --version | awk '{print $2}'))"
else
    bad "$APP/bin/kitty is missing — reinstall, see README.md"
fi

echo
echo "graphical session (hypr binds, .desktop, rofi)"
resolved=$(env -i PATH="$SESSION_PATH" sh -c 'command -v kitty' 2>/dev/null)
if [ -z "$resolved" ]; then
    bad "no kitty on the session PATH at all"
else
    ver=$(env -i PATH="$SESSION_PATH" sh -c 'kitty --version' 2>/dev/null | awk '{print $2}')
    case "$resolved" in
        /usr/local/bin/kitty) ok "$resolved  ($ver)" ;;
        *) bad "$resolved  ($ver)"
           note "expected /usr/local/bin/kitty — recreate the symlinks:"
           note "sudo ln -sf $APP/bin/kitty  /usr/local/bin/kitty"
           note "sudo ln -sf $APP/bin/kitten /usr/local/bin/kitten" ;;
    esac
fi

echo
echo "interactive shells"
shell_kitty=$(command -v kitty 2>/dev/null)
if [ -n "$shell_kitty" ]; then
    ok "$shell_kitty  ($(kitty --version 2>/dev/null | awk '{print $2}'))"
else
    bad "kitty not found on your shell PATH"
fi

echo
echo "symlinks"
for link in /usr/local/bin/kitty /usr/local/bin/kitten \
            "$HOME/.local/bin/kitty" "$HOME/.local/bin/kitten"; do
    if [ -L "$link" ]; then
        target=$(readlink -f "$link")
        case "$target" in
            "$APP"/*) ok "$link -> $target" ;;
            *) bad "$link -> $target  (not the upstream install)" ;;
        esac
    else
        bad "$link is missing"
    fi
done

echo
if [ "$fail" -eq 0 ]; then
    printf '\033[32mall good\033[m — test input with: python3 %s/keycap.py 7\n\n' "$HOME/.config/kitty"
else
    printf '\033[31mproblems found\033[m — see %s/README.md\n\n' "$HOME/.config/kitty"
fi
exit "$fail"
