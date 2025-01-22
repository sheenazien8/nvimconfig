require "config.options"
require "config.keymap"
require "config.lazy"
require "custom.statusline"

local tinker = require("custom.tinker")

tinker.setup({
    split_direction = "horizontal", -- or "horizontal"
    split_size = 20, -- width or height of the split
    file_to_watch = "tinker.php", -- file to watch for changes
})

require("custom.terminal").setup()

-- vim.cmd "colorscheme gruvbox"
vim.cmd("colorscheme kanagawa")
