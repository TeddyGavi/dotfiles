local M = {}

local config = require("rem_ghost.config")
local decimal_count = config.options.decimal_count or 3

function M.convert_unit(value, unit, base_font_size)
  local fmt
  local changed = false
	local num = tonumber(value)
  if not decimal_count then
		local res, dec = tostring(value):match("%.(%d+)")
    print(res, dec)
		decimal_count = dec and #dec or 0
	end

	if unit == "px" then
    changed = true
    fmt = "%." .. decimal_count .. "frem"
		return string.format(fmt, num / base_font_size), changed
	elseif unit == "rem" or unit == "em" then
    changed = true
    fmt = "%." .. decimal_count .. "fpx"
		return string.format(fmt, num * base_font_size), changed
	else
		return value .. unit, changed
	end
end

return M
