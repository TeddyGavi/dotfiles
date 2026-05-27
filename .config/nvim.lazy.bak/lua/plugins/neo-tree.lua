return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = false,
  opts = {
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function()
          vim.cmd([[
              setlocal relativenumber
            ]])
        end,
      },
    },
  }
}
