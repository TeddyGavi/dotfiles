local M = {}

function M.setup(opts)
  require('rem_ghost.config').setup(opts)
  require('rem_ghost.core').init_autocmds()
end

return M
