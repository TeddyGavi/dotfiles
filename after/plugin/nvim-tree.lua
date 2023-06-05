vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local nvim_tree = require("nvim-tree")
nvim_tree.setup()

vim.keymap.set('n', '<C-n>', ':NvimTreeFindFileToggle<CR>')
