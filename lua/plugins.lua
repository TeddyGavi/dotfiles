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
    lazy = true,
  },
}