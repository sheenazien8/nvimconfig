local M = {}

M.config = {
  file_path = "tinker.php",
  width_percentage = 0.8,
  height_percentage = 0.8,
  border = "rounded",
  auto_run_on_save = true,
  window_mode = "floating", -- Options: "floating", "split"

  style = {
    floating = {
      blend = 0,
      winhl = "Normal:Normal",
    },
    split = {
      layout = "horizontal", -- Options: "horizontal", "vertical"
      height = 0.4, -- For horizontal split (relative to screen height)
      width = 0.5, -- For vertical split (relative to screen width)
      winhl = "Normal:Normal",
    },
  },

  background = {
    enabled = true,
    blend = 0,
    highlight = "Normal",
  },
}

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

local function prepare_tinker_command(content)
  local command = content:gsub("^%s*<%?php%s*", "")
  command = command:gsub('"', '\\"')
  command = command:gsub("'", '"')
  return "<?php\n" .. command
end

local function create_float_config()
  local width = vim.api.nvim_get_option "columns"
  local height = vim.api.nvim_get_option "lines"

  local win_width = math.floor(width * M.config.width_percentage)
  local win_height = math.floor(height * M.config.height_percentage)

  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)

  return {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = M.config.border,
    noautocmd = M.config.background.enabled,
  }
end

local function apply_window_style(mode)
  local style = M.config.style[mode]
  if style then
    if style.blend then
      vim.api.nvim_win_set_option(M.tinker_win, "winblend", style.blend)
    end
    if style.winhl then
      vim.api.nvim_win_set_option(M.tinker_win, "winhl", style.winhl)
    end
  end
end

local function open_floating_window(result_lines)
  M.tinker_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(M.tinker_buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(M.tinker_buf, "bufhidden", "wipe")

  vim.api.nvim_buf_set_lines(M.tinker_buf, 0, -1, false, result_lines)

  local float_opts = create_float_config()
  M.tinker_win = vim.api.nvim_open_win(M.tinker_buf, true, float_opts)

  apply_window_style "floating"

  vim.api.nvim_buf_set_option(M.tinker_buf, "modifiable", false)
  vim.api.nvim_buf_set_option(M.tinker_buf, "filetype", "php")

  vim.api.nvim_set_current_win(M.tinker_win)
end

local function open_split_window(result_lines)
  M.tinker_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(M.tinker_buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(M.tinker_buf, "bufhidden", "wipe")

  vim.api.nvim_buf_set_lines(M.tinker_buf, 0, -1, false, result_lines)

  local layout = M.config.style.split.layout
  if layout == "vertical" then
    vim.cmd "vsplit"
  else
    vim.cmd "split"
  end

  M.tinker_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(M.tinker_win, M.tinker_buf)

  local width = vim.api.nvim_get_option "columns"
  local height = vim.api.nvim_get_option "lines"

  if layout == "horizontal" then
    local split_height = math.floor(height * M.config.style.split.height)
    vim.api.nvim_win_set_height(M.tinker_win, split_height)
  elseif layout == "vertical" then
    local split_width = math.floor(width * M.config.style.split.width)
    vim.api.nvim_win_set_width(M.tinker_win, split_width)
  end

  apply_window_style "split"

  vim.api.nvim_buf_set_option(M.tinker_buf, "modifiable", false)
  vim.api.nvim_buf_set_option(M.tinker_buf, "filetype", "php")
end

function M.run_tinker_from_file()
  M.prev_win = vim.api.nvim_get_current_win()

  M.close_tinker_window()

  local file = io.open(M.config.file_path, "r")
  if not file then
    vim.api.nvim_err_writeln("Could not open file " .. M.config.file_path)
    return
  end

  local content = file:read "*all"
  file:close()

  local command = prepare_tinker_command(content)
  local temp_file_path = vim.fn.tempname() .. ".php"
  local temp_file = io.open(temp_file_path, "w")
  temp_file:write(command)
  temp_file:close()

  local result = vim.fn.system("php artisan tinker " .. temp_file_path)
  os.remove(temp_file_path)

  local result_lines = vim.split(result, "\n")

  if M.config.window_mode == "floating" then
    open_floating_window(result_lines)
  elseif M.config.window_mode == "split" then
    open_split_window(result_lines)
  else
    vim.api.nvim_err_writeln("Invalid window_mode: " .. M.config.window_mode)
  end

  vim.api.nvim_buf_set_keymap(
    M.tinker_buf,
    "n",
    "q",
    '<Cmd>lua require("custom.tinker").close_tinker_window()<CR>',
    { noremap = true, silent = true }
  )
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  vim.api.nvim_create_user_command("RunTinkerFile", M.run_tinker_from_file, {})

  if M.config.auto_run_on_save then
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = M.config.file_path,
      callback = M.run_tinker_from_file,
    })
  end
end

return M
