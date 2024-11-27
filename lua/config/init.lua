require "config.options"
require "config.keymap"
require "config.lazy"
require "custom.statusline"

require("custom.tinker").setup {
  window_mode = "split",
  style = {
    split = {
      layout = "horizontal", -- Options: "horizontal", "vertical"
      height = 0.3, -- 30% of the screen height
      width = 0.4, -- Only used for vertical splits
      winhl = "Normal:Split",
    },
  },
}
