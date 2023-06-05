-- Navigate vim panes better
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' 
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true 
vim.opt.expandtab = true
vim.api.nvim_set_keymap("n", "<leader>pv", vim.cmd.Ex)

vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.autoread = true

-- vim.keymap.set("n", "<leader>h", :nohlsearch<CR>)

