local env = require "config.env"

return {
  "nvim-treesitter/nvim-treesitter",
  enabled = not env.is_server,
  build = ":TSUpdate",
  dependencies = {
    -- "JoosepAlviste/nvim-ts-context-commentstring",
    -- "nvim-treesitter/nvim-treesitter-textobjects",
  },
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "html",
      "lua",
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
      updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
    },
  },
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'go', 'php', 'blade', 'lua', 'javascriptreact', 'typescriptreact', 'json', 'html', 'md', 'vim', 'vimdoc', 'http', "yaml", "toml", "css", "js", "ts", "typescript", "dart", "kt" },
      callback = function() vim.treesitter.start() end,
    })
  end
}
