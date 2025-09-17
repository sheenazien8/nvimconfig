return {              -- Useful plugin to show you pending keybinds.
  "folke/which-key.nvim",
  event = "VimEnter", -- Sets the loading event to 'VimEnter'
  enabled = true,
  opts = {
    preset = "modern",
  },
  config = true,
}
