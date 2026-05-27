local M = {}

function M.setup(opts)
  require('jsx2scss.config').setup(opts)
  require('jsx2scss.core').init_autocmds()
end

return M
