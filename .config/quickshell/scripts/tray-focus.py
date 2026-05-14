#!/usr/bin/env python3
"""
Focus the Hyprland window belonging to a system tray item.

Usage: tray-focus.py <tray-item-id>

Strategy:
  1. Query StatusNotifierWatcher for all registered tray items.
  2. Find the D-Bus bus name that owns the item with the given Id.
  3. Ask the D-Bus daemon for the Unix PID of that bus name.
  4. Find the Hyprland window whose pid matches and focus it.
  5. Fall back to class/title matching if D-Bus lookup fails.
"""

import sys
import json
import subprocess

# ── helpers ──────────────────────────────────────────────────────────────────

def busctl_get(bus, path, iface, prop):
    r = subprocess.run(
        ["busctl", "--user", "get-property", bus, path, iface, prop],
        capture_output=True, text=True
    )
    # busctl format: 's "value"'  or  'as N "v1" "v2"'
    return r.stdout.strip()

def parse_string(raw):
    """Extract a plain string from busctl's 's "value"' output."""
    raw = raw.strip()
    if raw.startswith('s '):
        raw = raw[2:]
    return raw.strip('"')

def parse_string_array(raw):
    """Extract list of strings from busctl's 'as N "v1" "v2"' output."""
    import re
    return re.findall(r'"([^"]*)"', raw)

def get_pid_for_bus(bus_name):
    r = subprocess.run(
        ["busctl", "--user", "status", bus_name],
        capture_output=True, text=True
    )
    import re
    for line in r.stdout.splitlines():
        # Match only the "PID=..." line, not PPID or PIDFD
        m = re.match(r'^PID\s*[=:]\s*(\d+)', line)
        if m:
            return int(m.group(1))
    return None

def hyprctl_clients():
    r = subprocess.run(["hyprctl", "clients", "-j"], capture_output=True, text=True)
    try:
        return json.loads(r.stdout)
    except json.JSONDecodeError:
        return []

def focus_class(wm_class):
    subprocess.run(
        ["hyprctl", "dispatch", "focuswindow", f"class:{wm_class}"],
        capture_output=True
    )

# ── main ─────────────────────────────────────────────────────────────────────

def main():
    tray_id = sys.argv[1] if len(sys.argv) > 1 else ""

    # 1. Get registered StatusNotifierItems
    raw = busctl_get(
        "org.kde.StatusNotifierWatcher",
        "/StatusNotifierWatcher",
        "org.kde.StatusNotifierWatcher",
        "RegisteredStatusNotifierItems",
    )
    items = parse_string_array(raw)  # e.g. [":1.1384/StatusNotifierItem"]

    for item in items:
        if "/" not in item:
            continue
        bus_name, obj_path = item.split("/", 1)
        obj_path = "/" + obj_path

        # 2. Get the Id of this tray item
        raw_id = busctl_get(bus_name, obj_path, "org.kde.StatusNotifierItem", "Id")
        item_id = parse_string(raw_id)

        if item_id != tray_id:
            continue

        # 3. Get the PID for this bus name
        pid = get_pid_for_bus(bus_name)
        if not pid:
            continue

        # 4. Find matching Hyprland window by PID
        clients = hyprctl_clients()
        for client in clients:
            if client.get("pid") == pid:
                wm_class = client.get("class", "")
                if wm_class:
                    focus_class(wm_class)
                    return

    # 5. Fallback: derive class from the tray Id (works for non-Electron apps)
    app = tray_id.rsplit(".", 1)[-1]
    if app:
        subprocess.run(
            ["hyprctl", "dispatch", "focuswindow", f"class:{app}"],
            capture_output=True
        )
        subprocess.run(
            ["hyprctl", "dispatch", "focuswindow",
             f"class:{app[0].upper()}{app[1:]}"],
            capture_output=True
        )

if __name__ == "__main__":
    main()
