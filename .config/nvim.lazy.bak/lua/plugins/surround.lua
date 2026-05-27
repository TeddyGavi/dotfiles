return {
  'kylechui/nvim-surround',
  event = 'VeryLazy',
  version = '*',
  config = function()
    local nvim_surround = require('nvim-surround')
    nvim_surround.setup()
  end,
}
