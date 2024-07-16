require "config"

vim.filetype.add {
  pattern = {
    [".*%.blade%.php"] = "blade",
  },
}

-- autocmd setting
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_augroup("LuaFileSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "LuaFileSettings",
  pattern = "lua",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})

local tinker_buf = nil

local function run_tinker_from_file()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_get_current_buf()

  local file_path = "tinker.php"
  local file = io.open(file_path, "r")
  if not file then
    vim.api.nvim_err_writeln("Could not open file " .. file_path)
    return
  end
  local content = file:read "*all"
  file:close()

  local command = content:gsub("^%s*<%?php%s*", "")

  command = command:gsub('"', '\\"')
  command = command:gsub("'", '"')

  local result = vim.fn.system("php artisan tinker --execute='" .. command:gsub("\n", " ") .. "'")

  if tinker_buf and vim.api.nvim_buf_is_valid(tinker_buf) then
    vim.api.nvim_buf_delete(tinker_buf, { force = true })
  end

  vim.cmd "vnew"
  tinker_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_option(tinker_buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(tinker_buf, "bufhidden", "wipe")

  vim.api.nvim_buf_set_lines(tinker_buf, 0, -1, false, vim.split(result, "\n"))
  vim.api.nvim_buf_set_option(tinker_buf, "modifiable", false)

  vim.api.nvim_buf_set_option(tinker_buf, "filetype", "text")

  vim.api.nvim_set_current_win(current_win)
  vim.api.nvim_set_current_buf(current_buf)
end

vim.api.nvim_create_user_command("RunTinkerFile", run_tinker_from_file, {})

vim.api.nvim_exec(
  [[
  augroup RunTinkerFileOnSave
    autocmd!
    autocmd BufWritePost tinker.php :RunTinkerFile
  augroup END
]],
  false
)
