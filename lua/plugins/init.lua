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
  {
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set({ "n", "v" }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
    end,
  },
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
  {
    "tamton-aquib/duck.nvim",
    config = function()
      vim.keymap.set("n", "<leader>dd", function()
        require("duck").hatch()
      end, {})
      vim.keymap.set("n", "<leader>dk", function()
        require("duck").cook()
      end, {})
      vim.keymap.set("n", "<leader>da", function()
        require("duck").cook_all()
      end, {})
    end,
  },
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  }
}
