local M = {}

function M:is_available()
  return vim.bo.filetype == "scss"
end

function M:complete(params, callback)
  local line = params.context.cursor_before_line
  local px = line:match("(%d+)px$")
  local rem = line:match("([%d%.]+)rem$")
  local items = {}

  if px then
    local value = tonumber(px) / 16
    table.insert(items, {
      label = value .. "rem",
      insertText = value .. "rem",
      documentation = px .. "px → " .. value .. "rem"
    })
  elseif rem then
    local value = tonumber(rem) * 16
    table.insert(items, {
      label = value .. "px",
      insertText = value .. "px",
      documentation = rem .. "rem → " .. value .. "px"
    })
  end

  callback({ items = items, isIncomplete = false })
end

return M
