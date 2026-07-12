return {
    {
        name = "matugen",
        dir = vim.fn.stdpath("config") .. "/lua/matugen-nvim",
        priority = 1000,
        lazy = false,
        config = function()
            --vim.cmd("colorscheme matugen")
        end,
    },
}
