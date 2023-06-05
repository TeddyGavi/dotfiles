-- Navigate vim panes better 
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' 

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true 
vim.opt.expandtab = true
-- lin nums
vim.wo.number = true
vim.opt.relativenumber = true

vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.autoread = true
vim.opt.cursorline = true
vim.cmd [[ set noswapfile ]]

vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

