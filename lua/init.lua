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

--[[ vim.api.nvim_create_autocmd("FileType", {
  pattern = { "php", "blade" },
  callback = function()
    vim.lsp.start {
      name = "laravel-ls",
      cmd = { "/Users/sheenazien8/go/bin/laravel-ls" },
      -- if you want to recompile everytime
      -- the language server is started.
      -- Uncomment this line instead
      -- cmd = { '/path/to/laravel-ls/start.sh' },
      root_dir = vim.fn.getcwd(),
    }
  end,
}) ]]

--[[ vim.api.nvim_create_autocmd("FileType", {
  pattern = { "php", "blade" },
  callback = function()
    local client = vim.lsp.start {
      name = "blade-lsp",
      cmd = { "/Users/sheenazien8/Documents/Code/fun/blade-lsp.nvim/blade-lsp.nvim" },
      root_dir = vim.fs.root(0, { "composer.json", "artisan" }),
      on_error = function(code, err)
        vim.notify(err, vim.log.levels.ERROR)
      end,
    }

    if not client then
      vim.notify("Error starting client blade-lsp.nvim", vim.log.levels.ERROR)
      return
    end
  end,
}) ]]
