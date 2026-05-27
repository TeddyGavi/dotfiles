vim.cmd("let g:netrw_banner = 0")

vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.cmd([[set completeopt+=menuone,noselect,popup]])
vim.cmd(":hi statusline guibg=NONE")


require("core.statusline")
require('core.config.autocmds')
require('core.config.options')
