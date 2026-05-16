-- matugen-nvim: core highlight groups
local M = {}

function M.get(c)
	-- c = colors table from palette.lua
	-- Returns a flat table of { GroupName = { fg=, bg=, ... } }
	local hl = {}

	-- ── Editor UI ─────────────────────────────────────────────────────────────

	hl.Normal = { fg = c.fg, bg = c.bg_base }
	hl.NormalNC = { fg = c.fg_dim, bg = c.bg_dark }
	hl.NormalFloat = { fg = c.fg, bg = c.bg_float }
	hl.FloatBorder = { fg = c.border_hi, bg = c.bg_float }
	hl.FloatTitle = { fg = c.rose, bg = c.bg_float, bold = true }

	hl.Cursor = { fg = c.bg_base, bg = c.fg }
	hl.CursorIM = { link = "Cursor" }
	hl.CursorLine = { bg = c.bg_highlight }
	hl.CursorLineNr = { fg = c.rose, bold = true }
	hl.CursorColumn = { bg = c.bg_highlight }

	hl.LineNr = { fg = c.fg_muted }
	hl.SignColumn = { fg = c.fg_muted, bg = c.none }
	hl.FoldColumn = { fg = c.fg_muted, bg = c.none }
	hl.Folded = { fg = c.fg_dim, bg = c.bg_highlight }

	hl.Visual = { bg = c.bg_visual }
	hl.VisualNOS = { bg = c.bg_visual }

	hl.Search = { fg = c.bg_base, bg = c.rose }
	hl.IncSearch = { fg = c.bg_base, bg = c.gold }
	hl.CurSearch = { link = "IncSearch" }
	hl.Substitute = { fg = c.bg_base, bg = c.red }

	hl.StatusLine = { fg = c.fg_dim, bg = c.bg_surface }
	hl.StatusLineNC = { fg = c.fg_muted, bg = c.bg_dark }
	hl.WinBar = { fg = c.fg_dim, bg = c.none }
	hl.WinBarNC = { fg = c.fg_muted, bg = c.none }
	hl.WinSeparator = { fg = c.border, bg = c.none }
	hl.VertSplit = { link = "WinSeparator" }

	hl.TabLine = { fg = c.fg_muted, bg = c.bg_dark }
	hl.TabLineFill = { bg = c.bg_dark }
	hl.TabLineSel = { fg = c.fg, bg = c.bg_surface, bold = true }

	hl.Pmenu = { fg = c.fg_dim, bg = c.bg_float }
	hl.PmenuSel = { fg = c.fg, bg = c.bg_visual, bold = true }
	hl.PmenuSbar = { bg = c.bg_highlight }
	hl.PmenuThumb = { bg = c.border_hi }
	hl.PmenuKind = { fg = c.rose, bg = c.bg_float }
	hl.PmenuKindSel = { fg = c.rose, bg = c.bg_visual }

	hl.MatchParen = { fg = c.gold, bold = true, underline = true }

	hl.NonText = { fg = c.fg_subtle }
	hl.Whitespace = { fg = c.fg_subtle }
	hl.SpecialKey = { fg = c.fg_subtle }
	hl.EndOfBuffer = { fg = c.bg_base }

	hl.ColorColumn = { bg = c.bg_highlight }
	hl.Conceal = { fg = c.fg_muted }
	hl.Directory = { fg = c.rose }
	hl.Title = { fg = c.rose, bold = true }
	hl.Question = { fg = c.gold }
	hl.MoreMsg = { fg = c.gold }
	hl.ModeMsg = { fg = c.fg_dim, bold = true }
	hl.MsgSeparator = { fg = c.border }

	hl.ErrorMsg = { fg = c.red }
	hl.WarningMsg = { fg = c.gold }

	hl.SpellBad = { undercurl = true, sp = c.red }
	hl.SpellCap = { undercurl = true, sp = c.gold }
	hl.SpellLocal = { undercurl = true, sp = c.mauve }
	hl.SpellRare = { undercurl = true, sp = c.teal }

	hl.QuickFixLine = { bg = c.bg_visual }

	-- ── Syntax ────────────────────────────────────────────────────────────────

	hl.Comment = { fg = c.fg_muted, italic = true }
	hl.SpecialComment = { fg = c.fg_muted, italic = true }

	hl.Constant = { fg = c.gold }
	hl.String = { fg = c.gold }
	hl.Character = { fg = c.gold }
	hl.Number = { fg = c.gold }
	hl.Boolean = { fg = c.rose, italic = true }
	hl.Float = { fg = c.gold }

	hl.Identifier = { fg = c.fg }
	hl.Function = { fg = c.rose, bold = true }

	hl.Statement = { fg = c.rose }
	hl.Conditional = { fg = c.rose, italic = true }
	hl.Repeat = { fg = c.rose, italic = true }
	hl.Label = { fg = c.rose }
	hl.Operator = { fg = c.fg_dim }
	hl.Keyword = { fg = c.rose, italic = true }
	hl.Exception = { fg = c.red }

	hl.PreProc = { fg = c.mauve }
	hl.Include = { fg = c.mauve }
	hl.Define = { fg = c.mauve }
	hl.Macro = { fg = c.mauve }
	hl.PreCondit = { fg = c.mauve }

	hl.Type = { fg = c.mauve }
	hl.StorageClass = { fg = c.mauve }
	hl.Structure = { fg = c.mauve }
	hl.Typedef = { fg = c.mauve }

	hl.Special = { fg = c.rose_hi }
	hl.SpecialChar = { fg = c.gold }
	hl.Tag = { fg = c.rose }
	hl.Delimiter = { fg = c.fg_dim }
	hl.Debug = { fg = c.red }

	hl.Underlined = { underline = true }
	hl.Bold = { bold = true }
	hl.Italic = { italic = true }
	hl.Ignore = { fg = c.fg_subtle }
	hl.Error = { fg = c.red }
	hl.Todo = { fg = c.gold, bold = true }

	-- ── Treesitter ────────────────────────────────────────────────────────────

	hl["@comment"] = { link = "Comment" }
	hl["@comment.documentation"] = { fg = c.fg_muted, italic = true }
	hl["@comment.todo"] = { fg = c.gold, bold = true }
	hl["@comment.note"] = { fg = c.mauve, bold = true }
	hl["@comment.warning"] = { fg = c.gold, bold = true }
	hl["@comment.error"] = { fg = c.red, bold = true }

	hl["@variable"] = { fg = c.fg }
	hl["@variable.builtin"] = { fg = c.rose, italic = true }
	hl["@variable.parameter"] = { fg = c.fg_dim }
	hl["@variable.member"] = { fg = c.fg }

	hl["@constant"] = { fg = c.gold }
	hl["@constant.builtin"] = { fg = c.gold, italic = true }
	hl["@constant.macro"] = { fg = c.mauve }

	hl["@string"] = { fg = c.gold }
	hl["@string.documentation"] = { fg = c.gold, italic = true }
	hl["@string.regexp"] = { fg = c.rose_hi }
	hl["@string.escape"] = { fg = c.rose_hi }
	hl["@string.special"] = { fg = c.rose_hi }

	hl["@character"] = { fg = c.gold }
	hl["@character.special"] = { fg = c.rose_hi }
	hl["@number"] = { fg = c.gold }
	hl["@number.float"] = { fg = c.gold }
	hl["@boolean"] = { fg = c.rose, italic = true }

	hl["@function"] = { fg = c.rose, bold = true }
	hl["@function.builtin"] = { fg = c.rose, italic = true }
	hl["@function.call"] = { fg = c.rose }
	hl["@function.macro"] = { fg = c.mauve }
	hl["@function.method"] = { fg = c.rose, bold = true }
	hl["@function.method.call"] = { fg = c.rose }

	hl["@constructor"] = { fg = c.mauve }
	hl["@operator"] = { fg = c.fg_dim }
	hl["@punctuation.delimiter"] = { fg = c.fg_dim }
	hl["@punctuation.bracket"] = { fg = c.fg_dim }
	hl["@punctuation.special"] = { fg = c.rose_hi }

	hl["@keyword"] = { fg = c.rose, italic = true }
	hl["@keyword.function"] = { fg = c.rose, italic = true }
	hl["@keyword.operator"] = { fg = c.rose }
	hl["@keyword.import"] = { fg = c.mauve }
	hl["@keyword.storage"] = { fg = c.mauve }
	hl["@keyword.return"] = { fg = c.rose, italic = true }
	hl["@keyword.exception"] = { fg = c.red }
	hl["@keyword.conditional"] = { fg = c.rose, italic = true }
	hl["@keyword.conditional.ternary"] = { fg = c.rose }
	hl["@keyword.repeat"] = { fg = c.rose, italic = true }
	hl["@keyword.directive"] = { fg = c.mauve }
	hl["@keyword.modifier"] = { fg = c.mauve }

	hl["@type"] = { fg = c.mauve }
	hl["@type.builtin"] = { fg = c.mauve, italic = true }
	hl["@type.definition"] = { fg = c.mauve }

	hl["@attribute"] = { fg = c.mauve }
	hl["@property"] = { fg = c.fg_dim }
	hl["@tag"] = { fg = c.rose }
	hl["@tag.builtin"] = { fg = c.rose }
	hl["@tag.attribute"] = { fg = c.gold }
	hl["@tag.delimiter"] = { fg = c.fg_dim }

	hl["@module"] = { fg = c.mauve }
	hl["@label"] = { fg = c.rose }

	hl["@markup.strong"] = { bold = true }
	hl["@markup.italic"] = { italic = true }
	hl["@markup.underline"] = { underline = true }
	hl["@markup.strikethrough"] = { strikethrough = true }
	hl["@markup.heading"] = { fg = c.rose, bold = true }
	hl["@markup.heading.1"] = { fg = c.rose, bold = true }
	hl["@markup.heading.2"] = { fg = c.mauve, bold = true }
	hl["@markup.heading.3"] = { fg = c.gold, bold = true }
	hl["@markup.quote"] = { fg = c.fg_dim, italic = true }
	hl["@markup.math"] = { fg = c.gold }
	hl["@markup.link"] = { fg = c.rose, underline = true }
	hl["@markup.link.url"] = { fg = c.gold, underline = true }
	hl["@markup.link.label"] = { fg = c.mauve }
	hl["@markup.raw"] = { fg = c.teal }
	hl["@markup.list"] = { fg = c.rose }
	hl["@markup.list.checked"] = { fg = c.green }
	hl["@markup.list.unchecked"] = { fg = c.fg_muted }

	-- ── LSP semantic tokens ────────────────────────────────────────────────────

	hl["@lsp.type.class"] = { link = "@type" }
	hl["@lsp.type.comment"] = { link = "Comment" }
	hl["@lsp.type.decorator"] = { link = "@attribute" }
	hl["@lsp.type.enum"] = { link = "@type" }
	hl["@lsp.type.enumMember"] = { link = "@constant" }
	hl["@lsp.type.function"] = { link = "@function" }
	hl["@lsp.type.interface"] = { link = "@type" }
	hl["@lsp.type.macro"] = { link = "@constant.macro" }
	hl["@lsp.type.method"] = { link = "@function.method" }
	hl["@lsp.type.namespace"] = { link = "@module" }
	hl["@lsp.type.parameter"] = { link = "@variable.parameter" }
	hl["@lsp.type.property"] = { link = "@property" }
	hl["@lsp.type.struct"] = { link = "@type" }
	hl["@lsp.type.type"] = { link = "@type" }
	hl["@lsp.type.typeParameter"] = { link = "@type" }
	hl["@lsp.type.variable"] = { link = "@variable" }
	hl["@lsp.mod.deprecated"] = { strikethrough = true }
	hl["@lsp.mod.readonly"] = { italic = true }

	-- ── Diagnostics ───────────────────────────────────────────────────────────

	hl.DiagnosticError = { fg = c.diag_error }
	hl.DiagnosticWarn = { fg = c.diag_warn }
	hl.DiagnosticInfo = { fg = c.diag_info }
	hl.DiagnosticHint = { fg = c.diag_hint }
	hl.DiagnosticOk = { fg = c.green }

	hl.DiagnosticVirtualTextError = { fg = c.diag_error, bg = c.red_bg, italic = true }
	hl.DiagnosticVirtualTextWarn = { fg = c.diag_warn, bg = c.gold_dim, italic = true }
	hl.DiagnosticVirtualTextInfo = { fg = c.diag_info, bg = c.mauve_dim, italic = true }
	hl.DiagnosticVirtualTextHint = { fg = c.diag_hint, bg = c.none, italic = true }

	hl.DiagnosticUnderlineError = { undercurl = true, sp = c.diag_error }
	hl.DiagnosticUnderlineWarn = { undercurl = true, sp = c.diag_warn }
	hl.DiagnosticUnderlineInfo = { undercurl = true, sp = c.diag_info }
	hl.DiagnosticUnderlineHint = { undercurl = true, sp = c.diag_hint }

	hl.DiagnosticSignError = { fg = c.diag_error }
	hl.DiagnosticSignWarn = { fg = c.diag_warn }
	hl.DiagnosticSignInfo = { fg = c.diag_info }
	hl.DiagnosticSignHint = { fg = c.diag_hint }

	hl.DiagnosticFloatingError = { fg = c.diag_error }
	hl.DiagnosticFloatingWarn = { fg = c.diag_warn }
	hl.DiagnosticFloatingInfo = { fg = c.diag_info }
	hl.DiagnosticFloatingHint = { fg = c.diag_hint }

	-- ── Diff ──────────────────────────────────────────────────────────────────

	hl.DiffAdd = { fg = c.diff_add, bg = c.gold_dim }
	hl.DiffChange = { fg = c.diff_change, bg = c.mauve_dim }
	hl.DiffDelete = { fg = c.diff_delete, bg = c.red_bg }
	hl.DiffText = { fg = c.diff_text, bg = c.primary_container, bold = true }

	-- ── Git signs (gitsigns.nvim) ──────────────────────────────────────────────

	hl.GitSignsAdd = { fg = c.diff_add }
	hl.GitSignsChange = { fg = c.diff_change }
	hl.GitSignsDelete = { fg = c.diff_delete }
	hl.GitSignsAddNr = { link = "GitSignsAdd" }
	hl.GitSignsChangeNr = { link = "GitSignsChange" }
	hl.GitSignsDeleteNr = { link = "GitSignsDelete" }
	hl.GitSignsAddLn = { bg = c.gold_dim }
	hl.GitSignsChangeLn = { bg = c.mauve_dim }
	hl.GitSignsDeleteLn = { bg = c.red_bg }

	-- ── Telescope ─────────────────────────────────────────────────────────────

	hl.TelescopeNormal = { fg = c.fg_dim, bg = c.bg_float }
	hl.TelescopeBorder = { fg = c.border_hi, bg = c.bg_float }
	hl.TelescopePromptNormal = { fg = c.fg, bg = c.bg_highlight }
	hl.TelescopePromptBorder = { fg = c.rose, bg = c.bg_highlight }
	hl.TelescopePromptTitle = { fg = c.bg_base, bg = c.rose, bold = true }
	hl.TelescopePromptPrefix = { fg = c.rose }
	hl.TelescopeResultsTitle = { fg = c.bg_base, bg = c.mauve, bold = true }
	hl.TelescopePreviewTitle = { fg = c.bg_base, bg = c.gold, bold = true }
	hl.TelescopeSelection = { bg = c.bg_visual }
	hl.TelescopeSelectionCaret = { fg = c.rose }
	hl.TelescopeMatching = { fg = c.gold, bold = true }

	-- ── nvim-cmp ──────────────────────────────────────────────────────────────

	hl.CmpItemAbbr = { fg = c.fg_dim }
	hl.CmpItemAbbrDeprecated = { fg = c.fg_muted, strikethrough = true }
	hl.CmpItemAbbrMatch = { fg = c.rose, bold = true }
	hl.CmpItemAbbrMatchFuzzy = { fg = c.rose }
	hl.CmpItemMenu = { fg = c.fg_muted, italic = true }
	hl.CmpItemKindDefault = { fg = c.fg_dim }
	hl.CmpItemKindKeyword = { fg = c.rose }
	hl.CmpItemKindFunction = { fg = c.rose }
	hl.CmpItemKindMethod = { fg = c.rose }
	hl.CmpItemKindConstructor = { fg = c.mauve }
	hl.CmpItemKindClass = { fg = c.mauve }
	hl.CmpItemKindEnum = { fg = c.mauve }
	hl.CmpItemKindInterface = { fg = c.mauve }
	hl.CmpItemKindType = { fg = c.mauve }
	hl.CmpItemKindStruct = { fg = c.mauve }
	hl.CmpItemKindField = { fg = c.fg_dim }
	hl.CmpItemKindProperty = { fg = c.fg_dim }
	hl.CmpItemKindVariable = { fg = c.fg }
	hl.CmpItemKindSnippet = { fg = c.gold }
	hl.CmpItemKindText = { fg = c.fg_dim }
	hl.CmpItemKindModule = { fg = c.mauve }
	hl.CmpItemKindUnit = { fg = c.gold }
	hl.CmpItemKindValue = { fg = c.gold }
	hl.CmpItemKindConstant = { fg = c.gold }
	hl.CmpItemKindEvent = { fg = c.rose }
	hl.CmpItemKindOperator = { fg = c.fg_dim }
	hl.CmpItemKindReference = { fg = c.rose_hi }
	hl.CmpItemKindColor = { fg = c.rose_hi }
	hl.CmpItemKindFile = { fg = c.fg_dim }
	hl.CmpItemKindFolder = { fg = c.rose }
	hl.CmpItemKindEnumMember = { fg = c.gold }
	hl.CmpItemKindTypeParameter = { fg = c.mauve }

	-- ── nvim-tree ─────────────────────────────────────────────────────────────

	hl.NvimTreeNormal = { fg = c.fg_dim, bg = c.bg_dark }
	hl.NvimTreeNormalNC = { fg = c.fg_muted, bg = c.bg_dark }
	hl.NvimTreeRootFolder = { fg = c.rose, bold = true }
	hl.NvimTreeFolderName = { fg = c.fg_dim }
	hl.NvimTreeFolderIcon = { fg = c.rose }
	hl.NvimTreeEmptyFolderName = { fg = c.fg_muted }
	hl.NvimTreeOpenedFolderName = { fg = c.rose_hi }
	hl.NvimTreeExecFile = { fg = c.green, bold = true }
	hl.NvimTreeOpenedFile = { fg = c.rose_hi, italic = true }
	hl.NvimTreeSymlink = { fg = c.mauve }
	hl.NvimTreeSpecialFile = { fg = c.gold, bold = true }
	hl.NvimTreeImageFile = { fg = c.mauve }
	hl.NvimTreeGitDirty = { fg = c.diff_change }
	hl.NvimTreeGitStaged = { fg = c.diff_add }
	hl.NvimTreeGitNew = { fg = c.diff_add }
	hl.NvimTreeGitDeleted = { fg = c.diff_delete }
	hl.NvimTreeIndentMarker = { fg = c.border }
	hl.NvimTreeWinSeparator = { fg = c.border, bg = c.bg_dark }

	-- ── Indent lines (indent-blankline) ───────────────────────────────────────

	hl.IblIndent = { fg = c.bg_highlight }
	hl.IblScope = { fg = c.border }
	hl.IblWhitespace = { fg = c.bg_highlight }

	-- ── Mini.nvim / which-key ─────────────────────────────────────────────────

	hl.WhichKey = { fg = c.rose }
	hl.WhichKeyGroup = { fg = c.mauve }
	hl.WhichKeyDesc = { fg = c.fg_dim }
	hl.WhichKeySeparator = { fg = c.border_hi }
	hl.WhichKeyFloat = { bg = c.bg_float }
	hl.WhichKeyBorder = { fg = c.border_hi, bg = c.bg_float }

	-- ── LSP hover / references ────────────────────────────────────────────────

	hl.LspReferenceText = { bg = c.bg_visual }
	hl.LspReferenceRead = { bg = c.bg_visual }
	hl.LspReferenceWrite = { bg = c.bg_visual, bold = true }
	hl.LspInlayHint = { fg = c.fg_muted, italic = true }
	hl.LspCodeLens = { fg = c.fg_muted, italic = true }
	hl.LspSignatureActiveParam = { fg = c.rose, bold = true, underline = true }

	-- store gold_dim for use in DiffVirtualText (needs raw access)
	hl._gold_dim = c.gold_dim

	return hl
end

return M
