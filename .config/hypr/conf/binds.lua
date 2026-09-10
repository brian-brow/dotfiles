-- binds.lua

-- Variables
local mainMod = "SUPER"
local terminal = "ghostty"
local fileManager = "nemo"
local menu = "rofi"
local browser = "zen-browser"
local toggleTui = "~/.config/hypr/scripts/toggle-tui.sh "

-- App launchers
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("vesktop"))
hl.bind(mainMod .. " + T", hl.dsp.window.close())
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("~/scripts/application_launcher.sh"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(toggleTui .. "yazi"))
-- hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("rofimoji"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-todo.sh"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/wlogout.sh"))
hl.bind(mainMod .. " + R", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("steam"))
-- hl.bind(mainMod .. " + W",   hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper.sh"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("qs ipc call wallpaper toggle"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(toggleTui .. "bluetui"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(toggleTui .. "nmtui"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(toggleTui .. "btop"))
--- hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("qs ipc call screenshot toggle"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("~/scripts/screenshot.sh"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("qs ipc call calculator toggle"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("blue-bubbles.AppImage"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen(1))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.exec_cmd("qs ipc call 8ball toggle"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("qs ipc call clipboard toggle"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))

-- Float + resize together
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + V", hl.dsp.window.resize({ x = 1000, y = 600 }))

-- Focus movement
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + CTRL + H", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.focus({ workspace = "e+1" }))

-- Resize (repeatable)
hl.bind("ALT + SHIFT + H", hl.dsp.window.resize({ x = "-40", y = "0", relative = "true" }), { repeating = true })
hl.bind("ALT + SHIFT + L", hl.dsp.window.resize({ x = "40", y = "0", relative = "true" }), { repeating = true })
hl.bind("ALT + SHIFT + K", hl.dsp.window.resize({ x = "0", y = "-40", relative = "true" }), { repeating = true })
hl.bind("ALT + SHIFT + J", hl.dsp.window.resize({ x = "0", y = "40", relative = "true" }), { repeating = true })

-- Move floating window (repeatable)
-- hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ x = "-40", y = "0", relative = "true" }), { repeating = true })
-- hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ x = "40", y = "0", relative = "true" }), { repeating = true })
-- hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ x = "0", y = "-40", relative = "true" }), { repeating = true })
-- hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ x = "0", y = "40", relative = "true" }), { repeating = true })

-- Workspacese

for i = 1, 5 do
	hl.bind(mainMod .. " + " .. i, function()
		local m = hl.get_monitor_at_cursor()
		if m then
			hl.dispatch(hl.dsp.focus({ workspace = m.id * 5 + i }))
		end
	end)

	hl.bind(mainMod .. " + SHIFT + " .. i, function()
		local m = hl.get_active_monitor()
		if m then
			hl.dispatch(hl.dsp.window.move({ workspace = m.id * 5 + i }))
		end
	end)
end

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))

-- Mouse drag to move/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Bare mouse scroll workspaces
hl.bind("mouse_right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("mouse_left", hl.dsp.focus({ workspace = "e-1" }))
