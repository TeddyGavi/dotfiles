return {
  "shortcuts/no-neck-pain.nvim",
  version = "*",
  opts = {
    width = 175,
  },
  config = function(_, opts)
    local no_neck_pain = require("no-neck-pain")
    local keymap = vim.keymap
    no_neck_pain.setup(opts)

    keymap.set("n", "<leader>pp", function()
      no_neck_pain.toggle()
    end, { desc = "Toggle Neck pain window" })
  end,
}
