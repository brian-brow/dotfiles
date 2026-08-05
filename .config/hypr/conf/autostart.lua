-- autostart.lua

hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("qs -p ~/.config/quickshell/shell.qml")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("mpv --no-video ~/.config/hypr/startup.mp3")
	-- hl.exec_cmd("~/.config/hypr/scripts/battery-notif.sh")
end)
