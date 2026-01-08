-- Laravel-specific keymaps that only work in PHP files

local function wrap_in_db_transaction()
  -- Check if current buffer is a PHP file
  if vim.bo.filetype ~= "php" then
    vim.notify("DB transaction wrapper only works in PHP files", vim.log.levels.WARN)
    return
  end

  -- Get the visual selection
  local start_row = vim.fn.line "'<"
  local end_row = vim.fn.line "'>"
  local start_col = vim.fn.col "'<"
  local end_col = vim.fn.col "'>"

  -- Get selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

  if #lines == 0 then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end

  -- Handle partial line selection for first and last lines
  if #lines == 1 then
    -- Single line selection
    local line = lines[1]
    lines[1] = string.sub(line, start_col, end_col)
  else
    -- Multi-line selection
    local first_line = lines[1]
    local last_line = lines[#lines]
    lines[1] = string.sub(first_line, start_col)
    lines[#lines] = string.sub(last_line, 1, end_col)
  end

  -- Get indentation from the first selected line
  local first_line_full = vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, false)[1]
  local indent = string.match(first_line_full, "^%s*") or ""

  -- Create the wrapped code
  local wrapped_lines = {}
  table.insert(wrapped_lines, indent .. "DB::beginTransaction();")
  table.insert(wrapped_lines, indent .. "try {")

  -- Add the selected code with additional indentation
  for _, line in ipairs(lines) do
    if line:match("^%s*$") then
      -- Preserve empty lines
      table.insert(wrapped_lines, "")
    else
      -- Add extra indentation to non-empty lines
      table.insert(wrapped_lines, indent .. "    " .. line:gsub("^%s*", ""))
    end
  end

  table.insert(wrapped_lines, "")
  table.insert(wrapped_lines, indent .. "    DB::commit();")
  table.insert(wrapped_lines, indent .. "    // Success response")
  table.insert(wrapped_lines, indent .. "} catch (Exception $e) {")
  table.insert(wrapped_lines, indent .. "    DB::rollback();")
  table.insert(wrapped_lines, indent .. "    // Handle error")
  table.insert(wrapped_lines, indent .. "    throw $e;")
  table.insert(wrapped_lines, indent .. "}")

  -- Replace the selected text with wrapped version
  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, wrapped_lines)

  vim.notify("Code wrapped in DB transaction", vim.log.levels.INFO)
end

return {
  v = {
    ["<leader>dt"] = {
      wrap_in_db_transaction,
      { desc = "Wrap selection in DB transaction (PHP only)" }
    },
  },
}

