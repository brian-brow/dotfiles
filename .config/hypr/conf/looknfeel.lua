-- looknfeel.lua

hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 2,
		border_size = 0,

		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {

		rounding = 10,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 0.9,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			size = 6,
			passes = 3,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = false,
	},
})
