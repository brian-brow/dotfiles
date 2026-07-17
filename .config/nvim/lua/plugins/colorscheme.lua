return {
    { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = true },
    { "folke/tokyonight.nvim", name = "tokyonight", lazy = true },
    { "catppuccin/nvim", name = "catppuccin", lazy = true },
    { "rose-pine/neovim", name = "rose-pine", lazy = true },
    { "rebelot/kanagawa.nvim", name = "kanagawa", lazy = true },
    { "scottmckendry/cyberdream.nvim", name = "cyberdream", lazy = true },
    {
        "navarasu/onedark.nvim",
        lazy = true,
        opts = {
            style = "cool",
        },
        config = function(_, opts)
            require("onedark").setup(opts)
            require("onedark").load()
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        lazy = true,
        opts = {},
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "moonfly",
        },
    },
}
