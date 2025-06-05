return {
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  "editorconfig/editorconfig-vim",
  "tpope/vim-fugitive",
  { "wakatime/vim-wakatime", lazy = false },
  {
    "jwalton512/vim-blade",
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
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
  {
    "preservim/vimux",
  },
  {
    "shabaraba/pile.nvim",
    enabled = false,
    opts = {},
  },
  {
    "lewis6991/satellite.nvim",
    enabled = false,
    config = function()
      require("satellite").setup {}
    end,
  },
  {
    "jake-stewart/auto-cmdheight.nvim",
    lazy = false,
    opts = {
      -- max cmdheight before displaying hit enter prompt.
      max_lines = 5,

      -- number of seconds until the cmdheight can restore.
      duration = 2,

      -- whether key press is required to restore cmdheight.
      remove_on_key = true,

      -- always clear the cmdline after duration and key press.
      -- by default it will only happen when cmdheight changed.
      clear_always = false,
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinLeave" },
  },
  -- {
  --   "Wansmer/symbol-usage.nvim",
  --   event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
  --   config = function()
  --     require("symbol-usage").setup()
  --   end,
  -- },
  {
    "Wansmer/sibling-swap.nvim",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("sibling-swap").setup {}
    end,
  },
  "ggandor/leap.nvim",
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    config = function()
      -- Setup orgmode
      require("orgmode").setup {
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
      }
    end,
  },
  -- lazy.nvim
  {
    "rodrigoscc/http.nvim",
    config = function()
      require("http-nvim").setup()
    end,
    build = { ":TSUpdate http2", ":Http update_grammar_queries" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional: uses it as picker
      "ibhagwan/fzf-lua", -- optional: uses it as picker
      "folke/snacks.nvim", -- optional: uses it as picker
    },
  },
}
