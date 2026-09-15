local ns = vim.api.nvim_create_namespace("dashboard_border")

-- How far the frame sits from the window edge, as a fraction of the half-dimension
local INSET = 0.2

-- Draws a frame inset from the edge of the dashboard window
local function draw_border()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype ~= "snacks_dashboard" then
        return
    end

    local height, width = vim.api.nvim_win_get_height(win), vim.api.nvim_win_get_width(win)
    if height < 2 or width < 4 then
        return
    end

    -- Extmarks need a line to attach to, but the rendered buffer stops short of the window
    vim.bo[buf].modifiable = true
    for _ = 1, height - vim.api.nvim_buf_line_count(buf) do
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "" })
    end
    vim.bo[buf].modifiable = false

    local function mark(row, col, text)
        vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            virt_text = { { text, "SnacksDashboardHeader" } },
            virt_text_win_col = col,
        })
    end

    local left, top = math.floor(width / 2 * INSET), math.floor(height / 2 * INSET)
    local right, bottom = width - 1 - left, height - 1 - top
    if right - left < 2 or bottom - top < 2 then
        return
    end

    local span = ("═"):rep(right - left - 1)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    mark(top, left, "╔" .. span .. "╗")
    mark(bottom, left, "╚" .. span .. "╝")
    for row = top + 1, bottom - 1 do
        mark(row, left, "║")
        mark(row, right, "║")
    end
end

return {
    {
        "folke/snacks.nvim",
        init = function()
            -- Header and frame follow the active colorscheme's bright yellow
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = vim.g.terminal_color_11 })
                end,
            })
            vim.api.nvim_create_autocmd("User", {
                pattern = "SnacksDashboardUpdatePost",
                callback = vim.schedule_wrap(draw_border),
            })
        end,
        opts = {
            dashboard = {
                enabled = true,
                preset = {
                    header = [[
         ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
         ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
         ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
         ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
         ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
         ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
                    ]],
                },
                sections = {
                    { section = "header" },
                    { section = "keys", gap = 1, padding = 1 },
                    { section = "startup" },
                },
            },
        },
    },
}
