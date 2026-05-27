local M = {}

local ns = vim.api.nvim_create_namespace("rem-ghost")
local util = require("rem_ghost.utils.unit")
local config = require("rem_ghost.config")
local file_types = config.options.file_types or { "css", "scss", "sass" }
local show_virtual_text = config.options.show_virtual_text
local BASE_FONT_SIZE = config.options.root_font_size or 16

function M.get_virtual_text_config()
  return config.options.show_virtual_text
end

function M.clear_virtual_text(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

function M.update_virtual_text()
	local bufnr = vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		return
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	M.clear_virtual_text(bufnr)

	if show_virtual_text then
		for i, line in ipairs(lines) do
			local text = ""

			for value, unit in line:gmatch("(-?%d*%.?%d+)([a-zA-Z%%]+)") do
				local new_string, did_change = util.convert_unit(value, unit, BASE_FONT_SIZE)
				if did_change then
					if text ~= "" then
						text = text .. ", "
					end
					text = text .. value .. unit .. " -> " .. new_string
				end
			end

			if text ~= "" then
				vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
					virt_text = { { text, "Comment" } },
					virt_text_pos = "eol",
					priority = 100,
					hl_mode = "combine",
				})
			end
		end
	end
end

function M.convert_unit_under_cursor()
	local _, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local start_idx, end_idx, new_line
	local s, e, value, unit

	for s_idx, line_value, line_unit, e_idx in line:gmatch("()(-?%d*%.?%d+)([a-zA-Z%%]+)()") do
		if col + 1 >= s_idx and col + 1 <= e_idx then
			s, e, value, unit = tonumber(s_idx), e_idx - 1, line_value, line_unit
			break
		end
	end
	if not value then
		print("No value+unit pattern found at cursor")
		return
	end

	local new_string, _ = util.convert_unit(value, unit, BASE_FONT_SIZE)
	start_idx = (s or (col + 1))
	end_idx = (e or col - 1)
	new_line = line:sub(1, start_idx - 1) .. new_string .. line:sub(end_idx + 1)
	vim.api.nvim_set_current_line(new_line)
end

function M.convert_units_at_line()
	local line = vim.api.nvim_get_current_line()
	local new_line = line:gsub("(-?%d*%.?%d+)([a-zA-Z%%]+)", function(value, unit)
		local new_string, _ = util.convert_unit(value, unit, BASE_FONT_SIZE)
		return new_string
	end)
	vim.api.nvim_set_current_line(new_line)
end

function M.toggle_virtual_text()
  local virtual_text = M.get_virtual_text_config()
  if virtual_text then
    config.options.show_virtual_text = false
    M.clear_virtual_text(vim.api.nvim_get_current_buf())
    else
    config.options.show_virtual_text = true
    M.clear_virtual_text(vim.api.nvim_get_current_buf())
    M.update_virtual_text()
  end
end

function M.init_autocmds()
	local pattern = "*." .. table.concat(file_types, ",*.")
	vim.cmd(string.format(
		[[
		augroup RemGhost
			autocmd!
			autocmd BufEnter,BufWritePost,TextChanged,TextChangedI %s lua require'rem_ghost.core'.update_virtual_text()
		augroup END
	]],
		pattern
	))

	vim.api.nvim_create_user_command("RemGhostConvert", function()
		require("rem_ghost.core").convert_unit_under_cursor()
	end, { desc = "Convert px <-> rem/em under cursor" })

	vim.api.nvim_create_user_command("RemGhostConvertLine", function()
		require("rem_ghost.core").convert_units_at_line()
	end, { desc = "Convert px <-> rem/em at line" })

  vim.api.nvim_create_user_command("RemGhostToggleVirtualText", function()
    require("rem_ghost.core").toggle_virtual_text()
  end, { desc = "Toggle virtual text for rem/em conversions" })
end

return M
