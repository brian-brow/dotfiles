return {
    {
        "folke/snacks.nvim",
        opts = function(_, opts)
            opts.dashboard = opts.dashboard or {}
            opts.dashboard.preset = opts.dashboard.preset or {}
            opts.dashboard.preset.keys = vim.list_extend(opts.dashboard.preset.keys or {}, {
                { icon = "󰙨 ", key = "l", desc = "Leet", action = ":Leet" },
            })
        end,
    },
}
