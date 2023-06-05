local lsp = require('lsp-zero')
lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

lsp.setup()
