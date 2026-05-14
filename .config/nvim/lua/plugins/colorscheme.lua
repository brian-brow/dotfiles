return {
    { "bluz71/vim-moonfly-colors", name = "moonfly" },
    { "folke/tokyonight.nvim", name = "tokyonight" },
    { "catppuccin/nvim", name = "catppuccin" },
    { "rose-pine/neovim", name = "rose-pine" },
    { "rebelot/kanagawa.nvim", name = "kanagawa" },
    { "scottmckendry/cyberdream.nvim", name = "cyberdream" },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
        opts = {},
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "kanagawa",
        },
    },
}
