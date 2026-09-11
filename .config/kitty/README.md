# kitty install notes

**kitty does not come from apt.** It is the upstream build, installed by hand on
2026-08-14. Ubuntu's packaged 0.32.2 has an input bug that doubles every Backspace
and Enter inside herdr and tmux (details at the bottom).

Current version: **0.48.2**

## Where things live

| Path | What it is |
|---|---|
| `~/.local/kitty.app/` | the real install — binaries, libs, terminfo |
| `/usr/local/bin/kitty`, `kitten` | symlinks. **These are the ones that matter.** |
| `~/.local/bin/kitty`, `kitten` | symlinks, for interactive shells only |
| `/usr/bin/kitty` | apt's 0.32.2, still installed, unused, kept as a fallback |

### Why two sets of symlinks

The session is started by SDDM, which does not read `.zshrc` or `.profile`. So
Hyprland runs with the bare system `PATH` and **cannot see `~/.local/bin`**.
`/usr/local/bin` is in that PATH, ahead of `/usr/bin`, so it is what resolves `kitty`
for keybinds, `kitty.desktop`, rofi, and the hypr scripts. The `~/.local/bin` pair
only covers terminals launched from a shell.

If the `/usr/local/bin` symlinks go missing, Super+Return silently falls back to
apt's 0.32.2 and the input bug returns.

---

# Maintenance

## Check everything is healthy

```sh
~/.config/kitty/health.sh
```

Or by hand — this is what a keybind will actually launch:

```sh
env -i PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  sh -c 'kitty --version'
```

Must print **0.48.2**. If it prints 0.32.2, the `/usr/local/bin` symlinks are gone —
recreate them (see below).

## Update to a newer kitty

There is no built-in updater for a binary install. Upstream's instruction is to
re-run the installer. Do it with signature verification:

```sh
mkdir -p ~/kitty-upgrade && cd ~/kitty-upgrade
V=0.49.0          # <-- set the version you want

curl -fLO "https://github.com/kovidgoyal/kitty/releases/download/v$V/kitty-$V-x86_64.txz"
curl -fLO "https://github.com/kovidgoyal/kitty/releases/download/v$V/kitty-$V-x86_64.txz.sig"
curl -fL -o installer.sh https://sw.kovidgoyal.net/kitty/installer.sh

gpg --verify "kitty-$V-x86_64.txz.sig" "kitty-$V-x86_64.txz"
```

**Do not continue unless that says `Good signature from "Kovid Goyal"`** with
fingerprint `3CE1 780F 78DD 88DF 4519 4FD7 06BC 317B 515A CE7C`. The
"not certified with a trusted signature" warning after it is normal — it is about
local web-of-trust, not validity. If the key is missing:
`gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 3CE1780F78DD88DF45194FD706BC317B515ACE7C`

```sh
sh installer.sh launch=n installer="$PWD/kitty-$V-x86_64.txz"
```

The installer replaces `~/.local/kitty.app` in place and touches nothing else.
**The symlinks do not need recreating** — they point at a path that still exists.
Run the health check, then close and reopen your terminals.

Latest version number: `curl -s https://sw.kovidgoyal.net/kitty/current-version.txt`

## Recreate the symlinks

```sh
sudo ln -sf ~/.local/kitty.app/bin/kitty  /usr/local/bin/kitty
sudo ln -sf ~/.local/kitty.app/bin/kitten /usr/local/bin/kitten
ln -sf ~/.local/kitty.app/bin/kitty  ~/.local/bin/
ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/
hash -r
```

## Roll back to apt's kitty

```sh
sudo rm /usr/local/bin/kitty /usr/local/bin/kitten
rm ~/.local/bin/kitty ~/.local/bin/kitten
hash -r
```

Instant, no reinstall needed. The input bug comes back.

## Remove the upstream install completely

```sh
sudo rm /usr/local/bin/kitty /usr/local/bin/kitten
rm -f ~/.local/bin/kitty ~/.local/bin/kitten
rm -rf ~/.local/kitty.app
hash -r
```

Back to a stock apt-only setup.

## Test for the input bug

```sh
python3 ~/.config/kitty/keycap.py 7
```

Press Backspace once, then `q`.

- **One `7f` line** — correct.
- **Two `7f` lines, ~80–140 ms apart** — bug is present. The second byte is the key
  release. Check which kitty you are actually running.

---

# Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Backspace deletes two characters in herdr/tmux | running apt's 0.32.2 | health check, then recreate symlinks |
| No cursor trail animation | same — `cursor_trail` needs 0.37+ | same |
| Works in a terminal, broken from Super+Return | only `~/.local/bin` symlinks exist | recreate the `/usr/local/bin` pair |
| `kitty: command not found` after removing things | all symlinks gone and apt package purged | `sudo apt install kitty` or recreate symlinks |

---

# Background: the bug

Ubuntu noble ships kitty 0.32.2. When an application turns on kitty keyboard protocol
flags `7` — disambiguate escape codes, report event types, report alternate keys —
that version sends a **second byte on key release** for Backspace, Enter, and Tab.

The protocol spec forbids this. Those three keys must not report releases unless
"report all keys as escape codes" is also on, because without it they travel as plain
legacy bytes (`0x7f`, `0x0d`, `0x09`) carrying no press/release marker. A release is
byte-identical to a second press, so nothing downstream can filter it out.

Terminal multiplexers turn those flags on, which is why the damage showed up in herdr
and in tmux + neovim but never in a bare shell. Measured outside any multiplexer,
0.32.2 sent `7f` twice 77 ms apart — matching physical key-down time — while 0.48.2
sends it once. herdr was not at fault; it relayed what kitty gave it.

Also worth knowing: `cursor_trail 1` in `kitty.conf` did nothing on 0.32.2 (the option
arrived in 0.37) and is live now. And `update_check_interval 0` keeps this install
from nagging about updates, so nothing changes unless you run the steps above.

Related: [herdr #2502](https://github.com/herdrdev/herdr/issues/2502) ·
[herdr #1951](https://github.com/herdrdev/herdr/issues/1951) ·
[kitty #10331](https://github.com/kovidgoyal/kitty/issues/10331) (closed
"does not reproduce" — but it reproduced here on 0.32.2)
