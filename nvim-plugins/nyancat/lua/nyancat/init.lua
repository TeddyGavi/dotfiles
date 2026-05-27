local M = {}

function M.setup(opts)
	require("nyancat.config").setup(opts)
	require("nyancat.core")
end

return M
