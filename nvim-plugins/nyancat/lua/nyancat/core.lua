-- local M = {}
--
-- local pos = 1
-- local rainbow_pos = 1
-- local sprite_pos = 1
--
-- function M.nyan()
--   local catnum = vim.g.nyan_modoki_select_cat_face_number or 1
--   local anim = vim.g.nyan_modoki_animation_enabled ~= 0
--   local use_sprite = (catnum == 0) -- use sprite when catnum = 0
--
--   local frames
--   if use_sprite then
--     frames = catface
--   else
--     frames = catface[catnum]
--   end
--
--   if not frames then
--     return ""
--   end
--
-- if anim then
--   pos = (pos % #frames) + 1
--   sprite_pos = (sprite_pos % #catface) + 1
-- else
--   pos = 1
--   sprite_pos = 1
-- end
--
--   local face = frames[pos]
--
--   local win_width = vim.api.nvim_win_get_width(0)
--   local maxlen = math.floor(win_width / 2)
--   if maxlen < 1 then
--     return "%#NyanCat#" .. face
--   end
--
--   local cur = math.floor((vim.fn.line(".") / vim.fn.line("$")) * maxlen)
--   local fil = maxlen - cur
--
--   local out = {}
--
--   -- 🌈 rainbow bar
--   local wave_chars = { "░░", "▒▒", "▓▓", "██", "▓▓", "▒▒" }
--   local fade_hls = {
--     "NyanRed",
--     "NyanOrange",
--     "NyanYellow",
--     "NyanGreen",
--     "NyanBlue",
--     "NyanPurple",
--     "NyanFade1",
--     "NyanFade2",
--     "NyanFade3",
--     "NyanFade4",
--     "NyanFade5",
--   }
--
--   for i = 1, cur do
--     -- distance from cat (0 = closest)
--     local dist = cur - i
--
--     -- fade based on distance
--     local fade_idx = math.min(#fade_hls, math.floor(dist / 6) + 1)
--     local hl = fade_hls[fade_idx]
--
--     -- wave motion (offset by animation frame)
--     local wave_idx = ((i + rainbow_pos) % #wave_chars) + 1
--     local ch = wave_chars[wave_idx]
--
--     table.insert(out, "%#" .. hl .. "#" .. ch)
--   end
--
--   -- 😺 cat
--   table.insert(out, "%#NyanCat#" .. face)
--
--   -- ░ tail
--   if fil > 0 then
--     table.insert(out, "%#NyanEmpty#" .. string.rep("-", fil))
--   end
--
--   return table.concat(out)
-- end
--
-- return M

local M = {}
-- Configuration
local current_file = debug.getinfo(1, "S").source:sub(2) -- Get current file path, remove '@'
local dir = vim.fn.fnamemodify(current_file, ":h") .. "/data" -- Correctly resolve data directory
local index = 0
local images = {}
local offset = vim.g.nyancat_offset or 0

-- Function to display the current frame
local function nyan()
	local col = offset > 0 and offset or vim.o.columns - 7 + offset
	local line = vim.o.lines - vim.o.cmdheight
	local frame_path = images[(index % #images) + 1]
	local cmd = string.format(
		'printf "\\x1b[s\\x1b[%d;%dH" > /dev/tty && cat %s > /dev/tty && printf "\\x1b[u" > /dev/tty',
		line,
		col,
		vim.fn.shellescape(frame_path)
	)
	vim.fn.system(cmd)
	index = index + 1
end
-- Function to start the animation
function M.start()
	if vim.fn.has("gui_running") then
		vim.notify("Nyancat: Not supported in GUI mode", vim.log.levels.WARN)
		return
	end
	print("Nyancat: Start called")
	vim.notify("starting nyan cat", vim.log.levels.WARN)
	-- Load all 16 frame paths, with error handling
	for i = 0, 15 do
		local path = string.format("%s/nyan%03d.drcs", dir, i)
		if not vim.fn.filereadable(path) then
			vim.notify("Failed to find " .. path, vim.log.levels.ERROR)
			return
		end
		table.insert(images, path)
	end
	if #images == 0 then
		vim.notify("No images found in " .. dir, vim.log.levels.ERROR)
		return
	end
	-- Start timer: 50ms interval, repeat indefinitely
	local timer = vim.loop.new_timer()
	timer:start(50, 50, vim.schedule_wrap(nyan)) -- Use vim.schedule_wrap to run in main loop
	-- Store timer for potential cleanup (optional)
	M.timer = timer
end
-- Function to stop the animation
function M.stop()
	if M.timer then
		M.timer:stop()
		M.timer:close()
		M.timer = nil
	end
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		require("nyancat.core").start()
	end,
	once = true,
})

return M
