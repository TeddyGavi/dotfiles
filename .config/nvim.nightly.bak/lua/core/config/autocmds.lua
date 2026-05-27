-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
  pattern = { ".commitlintrc" },
  command = "set filetype=json",
})

-- Highlight ExtraWhitespace
vim.cmd([[highlight ExtraWhitespace ctermbg=red guibg=red]])

-- Define the ToggleWhitespaceMatch function
local function toggle_whitespace_match(mode)
  local pattern = mode == "i" and "\\s\\+\\%#\\@<!$" or "\\s\\+$"
  if vim.w.whitespace_match_number then
    vim.fn.matchdelete(vim.w.whitespace_match_number)
    vim.w.whitespace_match_number = vim.fn.matchadd("ExtraWhitespace", pattern)
  else
    -- Something went wrong, try to be graceful.
    vim.w.whitespace_match_number = vim.fn.matchadd("ExtraWhitespace", pattern)
  end
end

-- Function to check if the current buffer is a regular file buffer
local function is_regular_file_buffer()
  return vim.fn.bufname() ~= "" and vim.fn.index({ "NvimTree", "startify", "netrw", "Neotree" }, vim.bo.filetype) == -1
end

-- Create autocommand group
vim.api.nvim_create_augroup("WhitespaceMatch", { clear = true })

-- BufWinEnter autocommand for regular file buffers
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = "WhitespaceMatch",
  pattern = "*",
  callback = function()
    if is_regular_file_buffer() then
      vim.w.whitespace_match_number = vim.fn.matchadd("ExtraWhitespace", "\\s\\+$")
    end
  end,
})

-- InsertEnter autocommand for regular file buffers
vim.api.nvim_create_autocmd("InsertEnter", {
  group = "WhitespaceMatch",
  pattern = "*",
  callback = function()
    if is_regular_file_buffer() then
      toggle_whitespace_match("i")
    end
  end,
})

-- InsertLeave autocommand for regular file buffers
vim.api.nvim_create_autocmd("InsertLeave", {
  group = "WhitespaceMatch",
  pattern = "*",
  callback = function()
    if is_regular_file_buffer() then
      toggle_whitespace_match("n")
    end
  end,
})

-- Function to delete all trailing whitespace
local function delete_trailing_whitespace()
  local save_cursor = vim.fn.getpos(".")
  local save_search = vim.fn.getreg("/")
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setpos(".", save_cursor)
  vim.fn.setreg("/", save_search)
end

-- Create the command
vim.api.nvim_create_user_command("DeleteTrailingWhitespace", delete_trailing_whitespace, {})

-- vim.api.nvim_set_keymap('n', '<leader>dw', ':DeleteTrailingWhitespace<CR>', { noremap = true, silent = true })
--
-- vim.api.nvim_create_user_command(
--   'RepeatEdit',
--   function()
--     local count = 20
--     local function repeat_edit_iteration()
--       if count == 0 then return end
--       vim.cmd('normal ggVGd')
--       vim.cmd('write')
--       vim.cmd('normal P')
--       vim.cmd('write')
--       count = count - 1
--       vim.defer_fn(repeat_edit_iteration, math.random(1000, 3000))
--     end
--     repeat_edit_iteration()
--   end,
--   {}
-- )
--

-- Function to replace 'src/' or 'styles/' imports with '@Utilities/'
local function replace_src_or_styles_to_utilities()
  local save_cursor = vim.fn.getpos(".") -- Save the cursor position
  local save_search = vim.fn.getreg("/") -- Save the current search register
  vim.cmd([[%s/'\(src\/\|styles\/\)\(.*\)'/'@Utilities\/\2'/g]])
  vim.fn.setpos(".", save_cursor) -- Restore the cursor position
  vim.fn.setreg("/", save_search) -- Restore the search register
end

-- Create the command
vim.api.nvim_create_user_command("ReplaceSrcOrStylesToUtilities", replace_src_or_styles_to_utilities, {})

-- Function to replace 'services/' imports with '@Utilities/'
local function replace_services_to_utilities()
  local save_cursor = vim.fn.getpos(".") -- Save the cursor position
  local save_search = vim.fn.getreg("/") -- Save the current search register
  vim.cmd([[%s/'services\/\([^']*\)'/'@Utilities\/services\/\1'/g]])
  vim.fn.setpos(".", save_cursor) -- Restore the cursor position
  vim.fn.setreg("/", save_search) -- Restore the search register
end

vim.api.nvim_create_user_command("ReplaceServicesToUtilities", replace_services_to_utilities, {})

-- Function to swap keys and values for a given range
local function swap_keys_and_values_range(opts)
  local start_line = opts.line1
  local end_line = opts.line2
  local save_cursor = vim.fn.getpos(".") -- Save the cursor position
  local save_search = vim.fn.getreg("/") -- Save the current search register

  -- Run the substitution on the provided range
  vim.cmd(string.format("%d,%ds/\\v(\\w+):\\s*([^,]+)/\\2: \\1/g", start_line, end_line))

  vim.fn.setpos(".", save_cursor) -- Restore the cursor position
  vim.fn.setreg("/", save_search) -- Restore the search register
end

vim.api.nvim_create_user_command("SwapKeysAndValues", swap_keys_and_values_range, { range = true })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
