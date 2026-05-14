#!/bin/bash
pgrep -x "todo-app" >/dev/null 2>&1 && pkill -x "todo-app" || /home/brian/.local/bin/todo-app &
