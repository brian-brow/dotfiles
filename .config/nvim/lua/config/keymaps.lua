-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>px", function()
  vim.cmd("vsplit | Ex")
end, { desc = "Open file explorer (vsplit)" })

vim.keymap.set("n", "<leader>pv", function()
  vim.cmd("Ex")
end, { desc = "Open file explorer" })
