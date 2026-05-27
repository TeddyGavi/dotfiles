---@class Jsx2ScssOptions
---@field file_types string[] List of filetypes to enable plugin (default: { "css", "scss", "sass" })
---@field file_extensions table File extension patterns to match (default: { pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" } })

local M = {}

---Default plugin options
---@type Jsx2ScssOptions
M.options = {
	file_types = {
		"javascript",
		"javascriptreact",
		"typescriptreact",
	},
  file_extensions = {
		patterns = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  }
}

--- Setup function to configure plugin options
---@param opts Jsx2ScssOptions
function M.setup(opts)
	opts = opts or {}
	for k, v in pairs(opts) do
		M.options[k] = v
	end
end

return M
