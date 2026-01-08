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
    "shabaraba/pile.nvim",
    enabled = false,
    opts = {},
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
    'tjdevries/present.nvim'
  },
  {
    dir = "/Users/sheenazien8/Documents/Code/fun/rest.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, "http")
      end,
    }
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = true },
  },
  {                     -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    enabled = true,
    opts = {
      preset = "modern",
    },
    config = true,
  },
  {
    "NvChad/nvim-colorizer.lua",
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    -- optionally, override the default options:
    config = true,
    -- config = function()
    -- 	require("tailwindcss-colorizer-cmp").setup({
    -- 		color_square_width = 2,
    -- 	})
    -- end,
  },
  {
    "Bekaboo/dropbar.nvim",
    -- optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    config = function()
      local dropbar_api = require "dropbar.api"
      vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
    end,
  }
}
