return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "html",
      "lua",
      "markdown",
      "vim",
      "vimdoc",
      "php_only",
      "php",
      "phpdoc",
      "go",
      "tsx",
      "json",
      "blade",
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highliting = true },
    indent = { enable = true },
    textobjects = {
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
    },
  },
  config = function (_, opts)
    require("nvim-treesitter.configs").setup (opts)
  end
}
