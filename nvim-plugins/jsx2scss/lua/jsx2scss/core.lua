local M = {}
local config = require("jsx2scss.config")
-- local file_types = config.options.file_types or { "javascript", "javascriptreact", "typescriptreact" }
-- local patterns = config.options.file_extensions.patterns or { "*.js", "*.jsx", "*.ts", "*.tsx" }

local function ensure_file_exists(filepath)
	local dir = vim.fn.fnamemodify(filepath, ":h")
	if dir ~= "" and not vim.loop.fs_stat(dir) then
		vim.fn.mkdir(dir, "p")
	end
	if not vim.loop.fs_stat(filepath) then
		vim.fn.writefile({}, filepath)
	end
end
-- Find first .scss file in styles/ subdirectory (non-recursive)
local function find_scss_in_styles(buffer_dir)
	local styles_dir = buffer_dir .. "/styles"
	local stat = vim.loop.fs_stat(styles_dir)
	if not stat or stat.type ~= "directory" then
		return nil
	end

	local handle = vim.loop.fs_scandir(styles_dir)
	if not handle then
		return nil
	end

	while true do
		local name = vim.loop.fs_scandir_next(handle)
		if not name then
			break
		end
		if name:match("%.scss$") then
			return styles_dir .. "/" .. name
		end
	end
	return nil
end

-- Run jsx2scss on current buffer
function M.run(output_path)
	local input = vim.api.nvim_buf_get_name(0)
	if input == "" then
		vim.notify("No input file", vim.log.levels.ERROR)
		return
	end

	-- Start from current buffer's dir
	local buffer_dir = vim.fn.fnamemodify(input, ":h")
	local scss_file
	if output_path and output_path ~= "" then
		-- Use provided path, resolve relative to buffer directory
		if not vim.fn.isdirectory(vim.fn.fnamemodify(output_path, ":p:h")) then
			local abs_path = vim.fn.fnamemodify(buffer_dir .. "/" .. output_path, ":p")
			ensure_file_exists(abs_path)
			scss_file = abs_path
		else
			scss_file = vim.fn.fnamemodify(buffer_dir .. "/" .. output_path, ":p")
		end
	else
		-- Look for .scss in buffer_dir/styles/
		scss_file = find_scss_in_styles(buffer_dir)
		if not scss_file then
			vim.notify("No .scss file found in styles/ directory", vim.log.levels.ERROR)
			return
		end
	end
	local cmd = { "/Users/matt/scss-bem-gen/main", "-i", input, "-o", scss_file }
	local result = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		vim.notify("Error: " .. result, vim.log.levels.ERROR)
	else
		local relative_scss = vim.fn.fnamemodify(scss_file, ":~:.")
		vim.notify("Updated SCSS: " .. relative_scss, vim.log.levels.INFO)
	end
end

function M.init_autocmds()
	-- local group = vim.api.nvim_create_augroup("Jsx2Scss", { clear = true })

	-- vim.api.nvim_create_autocmd("BufWritePost", {
	-- 	group = group,
	-- 	callback = function()
	-- 		local ext = vim.fn.expand("%:e")
	-- 		local matches = false
	-- 		for _, pat in ipairs(patterns) do
	-- 			if pat == "*." .. ext then
	-- 				matches = true
	-- 				break
	-- 			end
	-- 		end
	-- 		if not matches then
	-- 			vim.notify("Run on a supported file type")
	-- 			return
	-- 		end
	-- 		M.run()
	-- 	end,
	-- 	desc = "Run jsx2scss after saving a JS/TS file",
	-- })

	vim.api.nvim_create_user_command("Jsx2Scss", function(opts)
		require("jsx2scss.core").run(opts.args ~= "" and opts.args or nil)
	end, { nargs = "?", desc = "Run jsx2scss" })
end

return M
