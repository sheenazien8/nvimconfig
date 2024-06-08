return {
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  "editorconfig/editorconfig-vim",
  "tpope/vim-fugitive",
  { "wakatime/vim-wakatime", lazy = false },
  {
    "jwalton512/vim-blade",
    -- enabled = false,
  },
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
  },
  {
    "tpope/vim-dadbod",
    "kristijanhusak/vim-dadbod-completion",
    "kristijanhusak/vim-dadbod-ui",
  },
}
