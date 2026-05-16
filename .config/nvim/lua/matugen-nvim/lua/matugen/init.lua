-- matugen-nvim colorscheme
-- Usage: colorscheme matugen
--   or:  require("matugen").setup({ transparent = false })

local M = {}

M.config = {
	transparent = false, -- true = no bg on Normal/NormalNC/etc.
	italic_comments = true,
	italic_keywords = true,
	bold_functions = true,
}

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

function M.load()
	if vim.g.colors_name then
		vim.cmd("highlight clear")
	end
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end

	vim.o.termguicolors = true
	vim.o.background = "dark"
	vim.g.colors_name = "matugen"

	local palette = require("matugen.palette")
	local c = palette.colors

	-- patch gold_dim that the groups file uses
	c.gold_dim = "#5c421a" -- tertiary_container (re-exposed for DiffVirtualText)
	c.primary_container = "#723338"

	-- apply transparency if requested
	if M.config.transparent then
		c.bg_base = "NONE"
		c.bg_dark = "NONE"
		c.bg_float = "NONE"
	end

	-- apply italic/bold prefs
	if not M.config.italic_comments then
		-- override happens naturally since groups table is built after this
	end

	local groups = require("matugen.groups.editor").get(c)

	-- Transparency overrides
	if M.config.transparent then
		groups.Normal = { fg = c.fg }
		groups.NormalNC = { fg = c.fg_dim }
		groups.NormalFloat = { fg = c.fg }
		groups.StatusLine = { fg = c.fg_dim }
		groups.StatusLineNC = { fg = c.fg_muted }
	end

	-- Apply italic/bold overrides
	if not M.config.italic_comments then
		groups.Comment["@comment"] = nil
		groups.Comment = { fg = c.fg_muted }
	end

	if not M.config.italic_keywords then
		for _, k in ipairs({
			"Keyword",
			"Conditional",
			"Repeat",
			"@keyword",
			"@keyword.function",
			"@keyword.return",
			"@keyword.conditional",
			"@keyword.repeat",
		}) do
			if groups[k] then
				groups[k].italic = false
			end
		end
	end

	if not M.config.bold_functions then
		for _, k in ipairs({ "Function", "@function", "@function.method" }) do
			if groups[k] then
				groups[k].bold = false
			end
		end
	end

	-- Set all highlight groups
	for name, opts in pairs(groups) do
		if name:sub(1, 1) ~= "_" then -- skip internal keys like _gold_dim
			local ok, err = pcall(vim.api.nvim_set_hl, 0, name, opts)
			if not ok then
				vim.notify("matugen: failed to set " .. name .. ": " .. err, vim.log.levels.WARN)
			end
		end
	end

	-- Terminal colors (16-color palette)
	vim.g.terminal_color_0 = c.bg_base
	vim.g.terminal_color_1 = c.red
	vim.g.terminal_color_2 = c.green
	vim.g.terminal_color_3 = c.gold
	vim.g.terminal_color_4 = c.blue
	vim.g.terminal_color_5 = c.mauve
	vim.g.terminal_color_6 = c.teal
	vim.g.terminal_color_7 = c.fg_dim
	vim.g.terminal_color_8 = c.fg_muted
	vim.g.terminal_color_9 = c.red
	vim.g.terminal_color_10 = c.green
	vim.g.terminal_color_11 = c.gold
	vim.g.terminal_color_12 = c.rose
	vim.g.terminal_color_13 = c.mauve
	vim.g.terminal_color_14 = c.teal
	vim.g.terminal_color_15 = c.fg
end

-- Auto-load when used as `colorscheme matugen`
M.load()

return M
