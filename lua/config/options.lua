-- system setting
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = ""
vim.opt.breakindent = true
vim.opt.undofile = false

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false

-- vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.inccommand = "split"
vim.opt.cursorline = false
vim.opt.scrolloff = 10
vim.opt.hlsearch = true
vim.opt.laststatus = 3

vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.pumheight = 10

vim.opt.swapfile = false


-- LSP configuration to suppress method not supported warnings
vim.lsp.set_log_level("off")
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

-- Suppress LSP method not supported notifications and other LSP spam
local notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" then
    -- Suppress various LSP error messages
    if msg:match("method.*is not supported") or
       msg:match("textDocument/codeAction") or
       msg:match("No code actions available") or
       msg:match("Request.*failed") then
      return
    end
  end
  notify(msg, level, opts)
end

-- Also suppress LSP handler errors
local original_handler = vim.lsp.handlers["textDocument/codeAction"]
vim.lsp.handlers["textDocument/codeAction"] = function(err, result, ctx, config)
  if err then
    -- Silently ignore code action errors
    return
  end
  if original_handler then
    return original_handler(err, result, ctx, config)
  end
end
