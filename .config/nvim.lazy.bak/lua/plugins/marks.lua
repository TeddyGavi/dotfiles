return {
  "chentoast/marks.nvim",
  branch = "master",
  opts = {
    default_mappings = true,
    signs = true,
    mappings = {},
  },
  config = function(_, opts)
    local marks = require("marks")
    marks.setup(opts)
  end,
}
