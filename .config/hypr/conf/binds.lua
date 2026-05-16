-- binds.lua

local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "nemo"
local menu = "rofi"
local browser = "zen-browser"

-- App launchers
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("vesktop"))
hl.bind(mainMod .. " + T", hl.dsp.window.close())
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("~/scripts/application_launcher.sh"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("qs ipc call network toggle"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
-- hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("rofimoji"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-todo.sh"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/wlogout.sh"))
-- hl.bind(mainMod .. " + R", hl.dsp.layout_msg("togglesplit"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("steam"))
-- hl.bind(mainMod .. " + W",   hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper.sh"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("qs ipc call wallpaper toggle"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("qs ipc call bluetooth toggle"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen(1))
hl.bind(mainMod .. " + 8", hl.dsp.exec_cmd("qs ipc call 8ball toggle"))

-- Float + resize together
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + V", hl.dsp.window.resize({ x = 1000, y = 600 }))

-- Focus movement
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- -- Resize (repeatable)
-- hl.binde("ALT + SHIFT + H", hl.dsp.window.resize_active(-40, 0))
-- hl.binde("ALT + SHIFT + L", hl.dsp.window.resize_active(40, 0))
-- hl.binde("ALT + SHIFT + K", hl.dsp.window.resize_active(0, -40))
-- hl.binde("ALT + SHIFT + J", hl.dsp.window.resize_active(0, 40))
--
-- -- Move floating window (repeatable)
-- hl.binde(mainMod .. " + CTRL + H", hl.dsp.window.move_active(-40, 0))
-- hl.binde(mainMod .. " + CTRL + L", hl.dsp.window.move_active(40, 0))
-- hl.binde(mainMod .. " + CTRL + K", hl.dsp.window.move_active(0, -40))
-- hl.binde(mainMod .. " + CTRL + J", hl.dsp.window.move_active(0, 40))

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

-- hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = "1", on_current_monitor = "false" }))

-- -- Workspaces: Two monitors (monitor id * 5 + n)
-- local function ws_for(n)
-- 	return string.format(
-- 		"hyprctl dispatch workspace $(( $(hyprctl monitors -j | jq '.[] | select(.focused == true).id') * 5 + %d ))",
-- 		n
-- 	)
-- end
-- local function move_ws_for(n)
-- 	return string.format(
-- 		"hyprctl dispatch movetoworkspace $(( $(hyprctl monitors -j | jq '.[] | select(.focused == true).id') * 5 + %d ))",
-- 		n
-- 	)
-- end
--
-- for i = 1, 5 do
-- 	hl.bind(mainMod .. " + " .. i, hl.dsp.exec_cmd(ws_for(i)))
-- 	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.exec_cmd(move_ws_for(i)))
-- end

-- One monitor (commented out)
-- for i = 1, 5 do
--   hl.bind(mainMod .. " + " .. i,         hl.dsp.workspace(i))
--   hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.move_to_workspace(i))
-- end

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))

-- Mouse drag to move/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Bare mouse scroll workspaces
hl.bind("mouse_right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("mouse_left", hl.dsp.focus({ workspace = "e-1" }))
