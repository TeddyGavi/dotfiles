---@class RemGhostOptions
---@field root_font_size integer Base font size for rem/em conversion (default: 16)
---@field decimal_count integer|nil Number of decimals in conversion output (default: auto)
---@field show_virtual_text boolean Show virtual text with conversions (default: true)
---@field add_cmp_source boolean Add nvim-cmp source for completions (default: false)
---@field file_types string[] List of filetypes to enable plugin (default: { "css", "scss", "sass" })

local M = {}
local BASE_FONT_SIZE = 16

---Default plugin options
---@type RemGhostOptions
M.options = {
	root_font_size = BASE_FONT_SIZE,
	decimal_count = nil,
	show_virtual_text = true,
	add_cmp_source = false,
	file_types = {
		"css",
		"scss",
		"sass",
	},
}

--- Setup function to configure plugin options
---@param opts RemGhostOptions
function M.setup(opts)
	opts = opts or {}
	for k, v in pairs(opts) do
		M.options[k] = v
	end
end

return M
