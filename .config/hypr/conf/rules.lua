-- rules.lua

-- Steam games
-- hl.window_rule({ match = { class = "^(steam_app_.*)$" }, fullscreen = true })

-- Todo app
-- hl.window_rule({ match = { class = "^(todo-app)$" }, float = true })
-- hl.window_rule({ match = { class = "^(todo-app)$" }, center = true })
-- hl.window_rule({ match = { class = "^(todo-app)$" }, move = "50% 0" })
-- hl.window_rule({ match = { class = "^(todo-app)$" }, animation = "slide top" })
-- hl.window_rule({ match = { class = "^(todo-app)$" }, opacity = 0.80 })

-- Global
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true,
})

-- Multimedia video tag
hl.window_rule({ match = { tag = "multimedia_video*" }, no_blur = true })
hl.window_rule({ match = { tag = "multimedia_video*" }, opacity = 1.0 })

-- Per-app opacity
hl.window_rule({ match = { class = "^(kitty)$" }, opacity = 0.95 })
-- hl.window_rule({ match = { class = "^(rofi)$" }, opacity = 0.1 })
-- hl.window_rule({ match = { class = "^(waybar)$" }, opacity = 0.85 })
-- hl.window_rule({ match = { class = "^(com.github.th_ch.youtube_music)$" }, opacity = 0.95 })
-- hl.window_rule({ match = { class = "^(vesktop)$" }, opacity = 0.95 })
hl.window_rule({ match = { class = "^(firefox)$" }, opacity = 0.95 })
hl.window_rule({ match = { class = "^(org.qutebrowser.qutebrowser)$" }, opacity = 0.95 })

-- Layer rules
hl.layer_rule({ match = { namespace = "rofi" }, blur = true })
hl.layer_rule({ match = { namespace = "rofi" }, ignore_alpha = 0.0 })
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true })
-- hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ match = { namespace = "quickshell" }, blur = true })
hl.layer_rule({ match = { namespace = "quickshell" }, ignore_alpha = 0.0 })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, ignore_alpha = 0.2 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, ignore_alpha = 0.2 })
-- hl.layer_rule({ match = { namespace = "waybar" }, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "selection" }, blur = false })
-- hl.layer_rule({ match = { namespace = "discord" }, blur = true })

-- Workspace to monitor assignment
for i = 1, 5 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
end
for i = 6, 10 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "desc:Dell Inc. DELL U2724DE HXWBGJ4" })
end
for i = 11, 15 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "desc:Dell Inc. DELL U2724DE BCSBGJ4" })
end
