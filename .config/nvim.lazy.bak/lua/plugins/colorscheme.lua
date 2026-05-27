return {
  "vague-theme/vague.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other plugins
  config = function()
    -- NOTE: you do not need to call setup if you don't want to.
    require("vague").setup({
      -- optional configuration here
    })
    vim.cmd("colorscheme vague")
  end,
  -- lua/plugins/rose-pine.lua
  -- "rose-pine/neovim",
  -- lazy = false, -- make sure we load this during startup if it is your main colorscheme
  -- priority = 1000, -- make sure to load this before all the other plugins
  -- name = "rose-pine",
  -- config = function()
  --   vim.cmd("colorscheme rose-pine")
  -- end,
  -- {
  --   "vague2k/vague.nvim",
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other plugins
  --   config = function()
  --     -- NOTE: you do not need to call setup if you don't want to.
  --     require("vague").setup({
  --         transparent = false,
  --     })
  --     vim.cmd("colorscheme vague")
  --   end
  -- },
  -- {
  --   "catppuccin/nvim",
  --   priority = 1000,
  --   lazy = false,
  --   name = "catppuccin",
  --   opts = {
  --     colorscheme = "catppuccin-mocha",
  --     transparent_background = true,
  --     integrations = {
  --       aerial = true,
  --       alpha = true,
  --       cmp = true,
  --       dashboard = true,
  --       flash = true,
  --       gitsigns = true,
  --       headlines = true,
  --       illuminate = true,
  --       indent_blankline = { enabled = true },
  --       leap = true,
  --       lsp_trouble = true,
  --       mason = true,
  --       markdown = true,
  --       mini = true,
  --       native_lsp = {
  --         enabled = true,
  --         underlines = {
  --           errors = { "undercurl" },
  --           hints = { "undercurl" },
  --           warnings = { "undercurl" },
  --           information = { "undercurl" },
  --         },
  --       },
  --       navic = { enabled = true, custom_bg = "lualine" },
  --       neotest = true,
  --       neotree = false,
  --       noice = true,
  --       notify = false,
  --       semantic_tokens = true,
  --       -- telescope = true,
  --       -- treesitter = true,
  --       -- treesitter_context = true,
  --       -- which_key = true,
  --     },
  --   },
  -- },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "catppuccin-mocha",
  --   },
  -- },
}
