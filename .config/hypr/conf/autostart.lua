-- autostart.lua

hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("sudo ydotoold")
	-- hl.exec_cmd("~/.config/hypr/scripts/battery-notif.sh")
	hl.exec_cmd("qs -p ~/.config/quickshell/shell.qml")
	-- hl.exec_cmd("libinput-gestures-setup start")
	hl.exec_cmd("sleep 0.5 && hyprlock")

	hl.exec_cmd("~/.config/hypr/scripts/watch-monitors.sh")
	hl.exec_cmd("hypridle")
end)
