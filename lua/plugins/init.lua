local env = require "config.env"

return {
  "tpope/vim-sleuth",
  "editorconfig/editorconfig-vim",
  "tpope/vim-fugitive",
  { "wakatime/vim-wakatime", lazy = false, enabled = not env.is_server },
  {
    "jwalton512/vim-blade",
  },
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
    enabled = not env.is_server,
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
      max_lines = 5,
      duration = 2,
      remove_on_key = true,
      clear_always = false,
    },
    enabled = not env.is_server,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    enabled = not env.is_server,
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinLeave" },
    enabled = not env.is_server,
  },
  {
    "Wansmer/sibling-swap.nvim",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("sibling-swap").setup {}
    end,
    enabled = not env.is_server,
  },
  "ggandor/leap.nvim",
  {
    "tjdevries/present.nvim",
    enabled = not env.is_server,
  },
  {
    dir = "/Users/sheenazien8/Documents/Code/fun/rest.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, "http")
      end,
    },
    enabled = not env.is_server,
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = true },
    enabled = not env.is_server,
  },
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    enabled = true,
    opts = {
      preset = "modern",
    },
    config = true,
  },
  {
    "NvChad/nvim-colorizer.lua",
    enabled = not env.is_server,
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    config = true,
    enabled = not env.is_server,
  },
  {
    "Bekaboo/dropbar.nvim",
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
    enabled = not env.is_server,
  },
  {
    "sheenazien8/jq.nvim",
    branch = "feat/range-support",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "grapp-dev/nui-components.nvim",
    },
    config = function()
      require("jq").setup()
      vim.api.nvim_create_user_command("JqVisual", function()
        require("jq").run_visual()
      end, { range = true })
    end,
    enabled = not env.is_server,
  },
}