#!/bin/bash
pgrep wlogout >/dev/null 2>&1 && killall wlogout || wlogout
