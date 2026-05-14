-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- disable diagnostics entirely
vim.diagnostic.config({
    virtual_text = false, -- removes inline error text
    signs = false, -- removes gutter signs
    underline = false, -- removes underlines
    update_in_insert = false,
})
