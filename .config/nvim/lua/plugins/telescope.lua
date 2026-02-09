return {
    "nvim-telescope/telescope.nvim",
    keys = {
        {
            "<leader>fc",
            function()
                require("telescope.builtin").find_files({
                    cwd = vim.fn.expand("~/.config"),
                    hidden = true,
                })
            end,
            desc = "Find in .config",
        },
    },
    opts = {
        defaults = {
            file_ignore_patterns = {
                "^.git/",
                "node_modules",
            },
        },
        pickers = {
            find_files = {
                hidden = true,
                find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
            },
        },
    },
}
