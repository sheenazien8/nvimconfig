require "config.options"
require "config.lazy"
require "custom.statusline"
-- require "config.keymaps.init"

local tinker = require "custom.tinker"

tinker.setup {
  split_direction = "horizontal", -- or "horizontal"
  split_size = 20, -- width or height of the split
  file_to_watch = "tinker.php", -- file to watch for changes
}

require("custom.terminal").setup()

vim.cmd "colorscheme gruvbox"
-- vim.cmd("colorscheme kanagawa")

-- autoloader keymaps for all files
local keymaps_dir = vim.fn.stdpath "config" .. "/lua/config/keymaps" -- Adjust the path
local handle
if vim.fn.has "win32" == 1 then
  handle = io.popen('dir /b "' .. keymaps_dir .. '"') -- Windows
else
  handle = io.popen('ls -1 "' .. keymaps_dir .. '"') -- Linux/macOS
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
    vim.keymap.set(mode, key, command, opts)
  end
end
