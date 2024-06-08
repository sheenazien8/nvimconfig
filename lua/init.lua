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
