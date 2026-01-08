require "config.options"
require "config.lazy"
require "custom.statusline"
-- require "config.keymaps.init"

local tinker = require "custom.tinker"

tinker.setup {
  split_direction = "horizontal", -- or "horizontal"
  split_size = 20,                -- width or height of the split
  file_to_watch = "tinker.php",   -- file to watch for changes
}

require("custom.auto_run_sh").setup()

vim.cmd "colorscheme ayu"
-- vim.cmd("colorscheme kanagawa")

-- Make cursorline more vibrant
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#2d3f4f', bold = true })

-- Make line numbers vibrant only in active buffer
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#00ffff' })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffff00', bold = true })
    vim.opt_local.cursorline = true
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
  callback = function()
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#666666' })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#666666', bold = true })
    vim.opt_local.cursorline = false
  end,
})

-- autoloader keymaps for all files
local keymaps_dir = vim.fn.stdpath "config" .. "/lua/config/keymaps" -- Adjust the path
local handle
if vim.fn.has "win32" == 1 then
  handle = io.popen('dir /b "' .. keymaps_dir .. '"') -- Windows
else
  handle = io.popen('ls -1 "' .. keymaps_dir .. '"')  -- Linux/macOS
end

local keymap_table = { n = {}, i = {}, v = {}, t = {} } -- Structure to hold keymaps

if handle then
  for filename in handle:lines() do
    if filename:match "%.lua$" then
      local module_name = "config.keymaps." .. filename:gsub("%.lua$", "")
      local success, mappings = pcall(require, module_name)
      if success and type(mappings) == "table" then
        if mappings.enabled ~= false then
          -- Merge the keymaps
          for mode, keys in pairs(mappings) do
            keymap_table[mode] = vim.tbl_extend("force", keymap_table[mode] or {}, keys)
          end
        end
      else
        print("Error loading keymap file:", filename, mappings)
      end
    end
    ::continue::
  end
  handle:close()
end

-- Function to apply keymaps with options
for mode, mappings in pairs(keymap_table) do
  for key, map in pairs(mappings) do
    local command, opts = map[1], map[2] or {} -- Extract command and opts

    -- Handle pattern option - creates autocmd for filetype-specific keymaps
    if opts.pattern then
      local pattern = opts.pattern
      opts.pattern = nil

      -- Ensure pattern is a table
      if type(pattern) == "string" then
        pattern = { pattern }
      end

      -- Create autocmd to set keymap on FileType
      vim.api.nvim_create_autocmd("FileType", {
        pattern = pattern,
        callback = function()
          vim.keymap.set(mode, key, command, opts)
        end,
      })
    else
      -- Global keymap (no pattern restriction)
      vim.keymap.set(mode, key, command, opts)
    end
  end
end
