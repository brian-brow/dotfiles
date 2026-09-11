-- autostart.lua

hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("swww img ~/dotfiles/Wallpapers/gradient.png")
	hl.exec_cmd("swww-daemon")
	hl.exec_cmd("swaync")
	hl.exec_cmd("~/.config/hypr/scripts/watch-monitors.sh")
	hl.exec_cmd("~/.config/hypr/scripts/usb-notify.sh")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("mpv --no-video ~/.config/hypr/startup.mp3")
end)
