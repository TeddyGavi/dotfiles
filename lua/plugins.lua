return {
  {
  -- Which-key Extension
  "folke/which-key.nvim",
   lazy = true,
  },
   -- Bufferline 
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons'
  },

   -- Colorscheme
  { 
    "catppuccin/nvim", 
    name = "catppuccin", 
    priority = 1000 
  },

  -- Lualine 
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },

   -- Hop (Better Navigation)
  {
    "phaazon/hop.nvim",
    lazy = true,
  },
   -- Nvimtree (File Explorer)
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },

  -- nvim-cmp Auto completion
  {
   "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "hrsh7th/cmp-path", -- source for file system paths
      "L3MON4D3/LuaSnip", -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets
      "onsails/lspkind.nvim", -- vs-code like pictograms
    },
  },
}
