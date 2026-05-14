-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
        vim.opt_local.signcolumn = "yes"
    end,
})

vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
    end,
})

vim.filetype.add({
    extension = {
        qss = "css",
    },
})

vim.api.nvim_create_user_command("SetColorscheme", function(opts)
    local new_colorscheme = opts.args
    local config_file = vim.fn.stdpath("config") .. "/lua/plugins/colorscheme.lua"

    -- Read the file
    local file = io.open(config_file, "r")
    if not file then
        vim.notify("colorscheme.lua not found", vim.log.levels.ERROR)
        return
    end

    local content = file:read("*all")
    file:close()

    -- Replace the colorscheme value
    local updated = content:gsub('(colorscheme%s*=%s*")[^"]*(")', "%1" .. new_colorscheme .. "%2")

    -- Write back to file
    file = io.open(config_file, "w")
    if file then
        file:write(updated)
        file:close()
        vim.cmd("colorscheme " .. new_colorscheme)
        vim.notify("Colorscheme set to: " .. new_colorscheme, vim.log.levels.INFO)
    end
end, {
    nargs = 1,
    complete = "color",
})
