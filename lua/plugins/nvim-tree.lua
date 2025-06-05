vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
end

local circles = require "circles"

circles.setup { icons = { empty = "", filled = "", lsp_prefix = "" } }

return {
  enabled = true,
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    on_attach = my_on_attach,
    sort = {
      sorter = "case_sensitive",
    },
    view = {
      width = 50,
      float = {
        enable = false,
      },
      side = "right",
    },
    renderer = {
      group_empty = true,
      icons = {
        glyphs = circles.get_nvimtree_glyphs(),
      },
    },
    filters = {
      dotfiles = false,
    },
    diagnostics = {
      enable = true,
    },
  },
}
