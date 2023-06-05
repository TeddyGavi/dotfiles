-- Navigate vim panes better 
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' 
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true 
vim.opt.expandtab = true
vim.keymap.set("n", "<leader>pv", ":Ex<CR>")

vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.autoread = true
vim.opt.cursorline = true
vim.cmd [[ set noswapfile ]]
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

