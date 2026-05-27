local M = {}

function M.extract_values_and_units(lines)
	local results = {}
	for _, line in ipairs(lines) do
		for value, unit in line:gmatch("(-?%d*%.?%d+)([a-zA-Z%%]+)") do
			table.insert(results, { value = value, unit = unit })
		end
	end
	return results
end

return M
