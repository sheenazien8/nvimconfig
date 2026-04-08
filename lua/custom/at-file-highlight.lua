local M = {}

local ns = vim.api.nvim_create_namespace("at_file_hl")

local block_query
local span_query

local function ensure_queries()
  if not block_query then
    local ok, q = pcall(vim.treesitter.query.parse, "markdown", [[
      (fenced_code_block) @code
      (indented_code_block) @code
    ]])
    block_query = ok and q or nil
  end

  if not span_query then
    local ok, q = pcall(vim.treesitter.query.parse, "markdown_inline", [[
      (code_span) @code
    ]])
    span_query = ok and q or nil
  end
end

local function collect_code_ranges(bufnr)
  ensure_queries()
  local ranges = {}

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
  if not ok or not parser then
    return ranges
  end

  local trees = parser:parse()
  if not trees or not trees[1] then
    return ranges
  end

  if block_query then
    for _, node in block_query:iter_captures(trees[1]:root(), bufnr, 0, -1) do
      local sr, _, er, _ = node:range()
      table.insert(ranges, { sr, er })
    end
  end

  local children = parser:children()
  local inline_parser = children and children["markdown_inline"]
  if inline_parser and span_query then
    for _, tree in ipairs(inline_parser:parse() or {}) do
      for _, node in span_query:iter_captures(tree:root(), bufnr, 0, -1) do
        local sr, _, er, _ = node:range()
        table.insert(ranges, { sr, er })
      end
    end
  end

  return ranges
end

local function in_code(ranges, row)
  for _, r in ipairs(ranges) do
    if row >= r[1] and row <= r[2] then
      return true
    end
  end
  return false
end

local function apply_line(bufnr, row, line)
  local col = 1
  while true do
    local s, e = line:find("@%S+", col)
    if not s then
      break
    end
    vim.api.nvim_buf_set_extmark(bufnr, ns, row, s - 1, {
      end_col = e,
      hl_group = "AtFileMention",
      priority = 150,
    })
    col = e + 1
  end
end

local function highlight_buf(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local code_ranges = collect_code_ranges(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for lnum, line in ipairs(lines) do
    local row = lnum - 1
    if not in_code(code_ranges, row) then
      apply_line(bufnr, row, line)
    end
  end
end

function M.setup()
  vim.api.nvim_set_hl(0, "AtFileMention", { link = "Special" })
  vim.api.nvim_set_hl(0, "at_file.marker", { link = "AtFileMention" })

  local group = vim.api.nvim_create_augroup("AtFileHighlight", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
    group = group,
    pattern = "*.md",
    callback = function(ev)
      highlight_buf(ev.buf)
    end,
  })

  vim.api.nvim_create_autocmd("TextChangedI", {
    group = group,
    pattern = "*.md",
    callback = function(ev)
      local row = vim.api.nvim_win_get_cursor(0)[1] - 1
      vim.api.nvim_buf_clear_namespace(ev.buf, ns, row, row + 1)
      local line = vim.api.nvim_buf_get_lines(ev.buf, row, row + 1, false)[1] or ""
      apply_line(ev.buf, row, line)
    end,
  })
end

return M
