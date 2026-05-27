---@class nyanCatOptions


local M = {}

---Default plugin options
---@type nyanCatOptions
M.options = {}

--- Setup function to configure plugin options
---@param opts nyanCatOptions
function M.setup(opts)
	opts = opts or {}
	for k, v in pairs(opts) do
		M.options[k] = v
	end
end

return M
