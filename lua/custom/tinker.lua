local M = {}

M.config = {
  output_buffer_name = "Tinker Output",
  split_direction = "vertical",
  split_size = 60,
  file_to_watch = "tinker.php",
}

local function open_or_reuse_output_buf(buf_name)
  local buf = vim.fn.bufnr(buf_name)
  if buf == -1 then
    if M.config.split_direction == "vertical" then
      vim.cmd("vsplit | vertical resize " .. M.config.split_size)
    else
      vim.cmd("split | resize " .. M.config.split_size)
    end
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, buf_name)
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "tinker-output")
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
  else
    local win = vim.fn.bufwinid(buf)
    if win == -1 then
      if M.config.split_direction == "vertical" then
        vim.cmd("vsplit | vertical resize " .. M.config.split_size)
      else
        vim.cmd("split | resize " .. M.config.split_size)
      end
      vim.api.nvim_win_set_buf(0, buf)
    else
      vim.api.nvim_set_current_win(win)
    end
  end
  return vim.fn.bufnr(buf_name)
end

function M.run_tinker()
  local prev_win = vim.api.nvim_get_current_win()

  local cmd = "php artisan tinker " .. vim.fn.shellescape(M.config.file_to_watch)
  local output = vim.fn.system(cmd)

  local buf = open_or_reuse_output_buf(M.config.output_buffer_name)

  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  if prev_win and vim.api.nvim_win_is_valid(prev_win) then
    vim.api.nvim_set_current_win(prev_win)
  end
end

function M.close_tinker_window()
  local buf = vim.fn.bufnr(M.config.output_buffer_name)
  if buf ~= -1 then
    local win = vim.fn.bufwinid(buf)
    if win ~= -1 and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

function M.setup(user_config)
  M.config = vim.tbl_deep_extend("force", M.config, user_config or {})

  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = M.config.file_to_watch,
    callback = M.run_tinker,
  })
end

return M
