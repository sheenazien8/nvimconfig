return {
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  "editorconfig/editorconfig-vim",
  "tpope/vim-fugitive",
  { "wakatime/vim-wakatime", lazy = false },
  {
    "jwalton512/vim-blade",
  },
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
  },
  -- {
  --   "tpope/vim-dadbod",
  --   "kristijanhusak/vim-dadbod-completion",
  --   "kristijanhusak/vim-dadbod-ui",
  -- },
  {
    "echasnovski/mini.bracketed",
    version = "*",
    config = function()
      require("mini.bracketed").setup()
    end,
  },
  {
    "echasnovski/mini.pairs",
    version = "*",
    config = function()
      require("mini.pairs").setup()
    end,
  },
  "mattn/emmet-vim",
  "adelarsq/vim-matchit",
  config = function()
    vim.cmd [[runtime macros/matchit.vim]]
  end,
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "ccaglak/larago.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
