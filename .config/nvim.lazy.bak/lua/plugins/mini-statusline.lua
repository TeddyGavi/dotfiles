return {
  "nvim-mini/mini.statusline",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  config = function(_, opts)
    require("mini.statusline").setup({})
  end,
}
