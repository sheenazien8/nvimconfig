local M = {}

function M.run_sh()
  local file = vim.fn.expand("%:p")
  if vim.fn.filereadable(file) == 0 then
    vim.notify("File does not exist: " .. file, vim.log.levels.ERROR)
    return
  end
  -- Make executable and run
  local output = vim.fn.system("chmod +x " .. vim.fn.shellescape(file) .. " && " .. vim.fn.shellescape(file))
  -- Buffer name for output
  local buf_name = "ShellOutput"
  local buf = vim.fn.bufnr(buf_name)
  if buf == -1 then
    -- Create new split with buffer
    vim.cmd("split " .. buf_name)
    buf = vim.fn.bufnr(buf_name)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'sh')
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
  else
    -- Reuse existing buffer
    local win = vim.fn.bufwinid(buf)
    if win == -1 then
      vim.cmd("split")
      vim.api.nvim_win_set_buf(0, buf)
    else
      vim.api.nvim_set_current_win(win)
    end
  end
  -- Set output content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, '\n'))
end

function M.setup()
  -- Removed auto-run on save
end

return M