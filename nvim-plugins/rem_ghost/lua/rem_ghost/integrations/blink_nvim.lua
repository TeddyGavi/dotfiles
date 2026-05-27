---@class px-to-rem.Provider
---@field root_font_size number
---@field decimal_count number
---@field filetypes string[]
local M = {}
M.__index = M

local config = require("rem_ghost.config")
local decimal_count = decimal_count or 3

-- Create a new instance of the provider
---@param opts? table
function M.new(opts)
	opts = vim.tbl_deep_extend("keep", opts or {}, config.options)

	return setmetatable({
		root_font_size = opts.root_font_size,
		decimal_count = opts.decimal_count or 3,
		filetypes = opts.filetypes,
	}, M)
end

-- Optional name
M.name = "rem_ghost"

-- Only activate for configured filetypes
function M:is_available()
	return vim.tbl_contains(config.options.file_types, vim.bo.filetype)
end

function M:log(...)
	vim.notify("[rem_ghost] " .. table.concat(vim.tbl_map(tostring, { ... }), " "), vim.log.levels.DEBUG)
end

-- Converts px or rem from text
---@return table|nil
function M:get_completions(context, callback)
	print("rem_ghost:get_completions", context.line, context.cursor[2])
  local line = context.line or ""
  local col = context.col or #line
  print("line:", line, "col:", col)
  -- local before_cursor = line:sub(1, col)
	local before_cursor = context.line:sub(1, context.cursor[2] - 1)
  -- local px = before_cursor:match("%d+%.?%d*")
  local px = 16;
  local rem = before_cursor:match("([%d%.]+)%s*rem$")

	if px then
		-- local value = tonumber(px) / config.options.root_font_size
		local rounded = string.format("%." .. decimal_count .. "f", px)
		local items = {
			label = rounded .. "rem",
			filterText = before_cursor,
			kind = vim.lsp.protocol.CompletionItemKind.Value,
			insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
			textEdit = {
				range = {
					start = { line = context.cursor[1] - 1, character = context.cursor[2] - px - 1 },
					["end"] = { line = context.cursor[1] - 1, character = context.cursor[2] - 1 },
				},
				newText = rounded .. "rem",
			},
			documentation = {
				kind = "markdown",
				value = string.format("%spx → %srem", px, rounded),
			},
		}
    print("items:", vim.inspect(table.concat(vim.tbl_map(tostring, items), ", ")))
		return items

	elseif rem then
		local value = tonumber(rem) * config.options.root_font_size
		local rounded = string.format("%." .. decimal_count .. "f", value)
		return {
			label = rounded .. "px",
			insertText = rounded .. "px",
			description = rem .. "rem → " .. rounded .. "px",
		}
	end

	return nil
end

return M
