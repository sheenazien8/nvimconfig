local M = {}

M.config = {}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  vim.api.nvim_create_user_command("Terminal", M.open_terminal, {})

  vim.api.nvim_create_user_command("TerminalToggle", M.toggle_terminal, {})
end

local terminal_bufnr = nil
local terminal_winid = nil

function M.open_terminal()
  if terminal_bufnr == nil or not vim.api.nvim_buf_is_valid(terminal_bufnr) then
    vim.cmd "vsplit"
    terminal_winid = vim.api.nvim_get_current_win()
    vim.cmd "terminal"
    terminal_bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(terminal_bufnr, "buflisted", false)
  else
    print(terminal_bufnr)
    print(terminal_winid)
    vim.api.nvim_buf_set_option(terminal_bufnr, "buflisted", false)
    -- vim.api.nvim_set_current_win(terminal_winid)
  end
end

function M.toggle_terminal()
  if terminal_bufnr == nil or not vim.api.nvim_buf_is_valid(terminal_bufnr) then
    M.open_terminal()
  else
    vim.api.nvim_set_current_win(terminal_winid)
  end
end

return M
