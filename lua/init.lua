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

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "blade", "php" },
  callback = function()
    vim.lsp.config("blade-lsp", {
      name = "blade-lsp",
      cmd = { "/Users/sheenazien8/Documents/Code/fun/blade-lsp.nvim/blade-lsp" },
      root_dir = vim.fs.dirname(vim.fs.find({ '.git', 'composer.json' }, { upward = true })[1]),
    })
    vim.lsp.enable("blade-lsp")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "php", "blade" },
  callback = function()
    vim.lsp.config("laravel-ls", {
      name = "laravel-ls",

      -- if laravel ls is in your $PATH
      cmd = { '/Users/sheenazien8/Documents/Code/fun/laravel-ls/build/laravel-ls', '--log-level', 'debug' },

      -- Absolute path
      -- cmd = { '/path/to/laravel-ls/build/laravel-ls' },

      -- if you want to recompile everytime
      -- the language server is started.
      -- cmd = { '/path/to/laravel-ls/start.sh' },

      root_dir = vim.fs.dirname(vim.fs.find({ '.git', 'composer.json' }, { upward = true })[1]),
    })
    vim.lsp.enable("laravel-ls")
  end
})
