local lsp = require('lsp-zero')
lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

lsp.setup()

-- You need to setup `cmp` after lsp-zero
-- default as per docs!
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  mapping = {
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  }
})
