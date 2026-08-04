return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "qmljs",
        -- Blazor: .razor files. `c_sharp` comes from the lang.dotnet extra;
        -- razor embeds html + c_sharp, so both need to be present.
        "razor",
        "html",
      })
    end,
  },
}
