local M = {}

M.config = {
  output_buffer_name = "Tinker Output",
  split_direction = "vertical",
  split_size = 60,
  file_to_watch = "tinker.php",
}

function M.run_tinker()
  M.prev_win = vim.api.nvim_get_current_win()

  M.close_tinker_window()

  local result = vim.fn.system("php artisan tinker " .. M.config.file_to_watch)
  local result_lines = vim.split(result, "\n")

  M.tinker_buf = vim.api.nvim_create_buf(false, true)
  local existing_buf = vim.fn.bufnr(M.tinker_buf)

  if existing_buf == -1 then
    if M.config.split_direction == "vertical" then
      vim.cmd("vsplit | vertical resize " .. M.config.split_size)
    else
      vim.cmd("split | resize " .. M.config.split_size)
    end
    existing_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(existing_buf, M.config.output_buffer_name)
    vim.api.nvim_win_set_buf(0, existing_buf)
  else
    if M.config.split_direction == "vertical" then
      vim.cmd("vert sb " .. existing_buf)
    else
      vim.cmd("sb " .. existing_buf)
    end
  end

  vim.api.nvim_buf_set_option(existing_buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(existing_buf, 0, -1, false, {})
  vim.api.nvim_buf_set_lines(existing_buf, 0, -1, false, result_lines)
  vim.api.nvim_buf_set_option(existing_buf, "modifiable", false)
  vim.api.nvim_buf_set_option(existing_buf, "readonly", true)
  vim.api.nvim_buf_set_option(existing_buf, "filetype", "tinker-output")

  vim.cmd "wincmd p"

  vim.api.nvim_buf_set_keymap(
    M.tinker_buf,
    "n",
    "q",
    '<Cmd>lua require("custom.tinker").close_tinker_window()<CR>',
    { noremap = true, silent = true }
  )
end

M.tinker_buf = nil
M.tinker_win = nil
M.prev_win = nil

function M.close_tinker_window()
  if M.tinker_win and vim.api.nvim_win_is_valid(M.tinker_win) then
    vim.api.nvim_win_close(M.tinker_win, true)
  end

  if M.tinker_buf and vim.api.nvim_buf_is_valid(M.tinker_buf) then
    vim.api.nvim_buf_delete(M.tinker_buf, { force = true })
  end

  M.tinker_win = nil
  M.tinker_buf = nil

  if M.prev_win and vim.api.nvim_win_is_valid(M.prev_win) then
    vim.api.nvim_set_current_win(M.prev_win)
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
