require "config"
local json_collection = require "json_collection"

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

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "php", "blade" },
--   callback = function()
--     vim.lsp.config("laravel-ls", {
--       name = "laravel-ls",
--
--       -- if laravel ls is in your $PATH
--       cmd = { '/Users/sheenazien8/Documents/Code/fun/laravel-ls/build/laravel-ls', '--log-level', 'debug' },
--
--       -- Absolute path
--       -- cmd = { '/path/to/laravel-ls/build/laravel-ls' },
--
--       -- if you want to recompile everytime
--       -- the language server is started.
--       -- cmd = { '/path/to/laravel-ls/start.sh' },
--
--       root_dir = vim.fs.dirname(vim.fs.find({ '.git', 'composer.json' }, { upward = true })[1]),
--     })
--     vim.lsp.enable("laravel-ls")
--   end
-- })

-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = "*",
--   callback = function()
--     local cwd = vim.fn.getcwd()
--     if cwd:match("sketchybar") then
--       vim.fn.jobstart({ "sketchybar", "--reload" }, { detach = true })
--       vim.notify("🔁 SketchyBar reloaded!", vim.log.levels.INFO)
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd ="
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = { "*" },
  callback = function()
    -- If quickfix list is empty, don't open
    local qf = vim.fn.getqflist()
    if qf and #qf > 0 then
      vim.cmd("botright copen 5")
    end
  end,
})

vim.api.nvim_create_user_command("CopyProjectPath", function()
  local cwd = vim.fn.getcwd()
  local file = vim.fn.expand("%:p")
  local relative = vim.fn.fnamemodify(file, ":.") -- makes it relative to cwd

  vim.fn.setreg("+", relative)
  print("Copied: " .. relative)
end, {})

vim.api.nvim_create_user_command("CopyPathWithLines", function(opts)
  -- Get project-relative path
  local file = vim.fn.expand("%:p")
  local relative = vim.fn.fnamemodify(file, ":.")

  local start_line
  local end_line

  if opts.range == 0 then
    -- Normal mode → current line
    start_line = vim.fn.line(".")
    end_line = start_line
  else
    -- Visual mode → range passed in <line1> <line2>
    start_line = opts.line1
    end_line = opts.line2
  end

  local result = string.format("%s L%d-L%d", relative, start_line, end_line)

  vim.fn.setreg("+", result)
  print("Copied: " .. result)
end, { range = true })


local function is_array(t)
  if type(t) ~= "table" then return false end
  local i = 0
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then
      return false
    end
  end
  return true
end

function Pluck(value, keys)
  if type(value) ~= "table" then
    return value
  end

  -- If it's an array: apply pluck to each item
  if is_array(value) then
    local out = {}
    for i, item in ipairs(value) do
      out[i] = Pluck(item, keys)  -- recurse into object
    end
    return out
  end

  -- If it's a single object: pluck keys
  local out = {}
  for _, key in ipairs(keys) do
    out[key] = value[key]
  end
  return out
end


Collection = json_collection
