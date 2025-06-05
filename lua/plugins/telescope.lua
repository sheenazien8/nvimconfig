return { -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable "make" == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },

    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  config = function()
    require("telescope").setup {
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_cursor(),
        },
        ["fzf"] = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case", -- this is default
        },
      },
      defaults = {
        file_ignore_patterns = { "%.git/", "node_modules/", "vendor/" },
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        sorting_strategy = "ascending",
        color_devicons = true,
        layout_strategy = "vertical",
        layout_config = {
          prompt_position = "top",
          horizontal = {
            width_padding = 0.04,
            height_padding = 0.1,
            preview_width = 0,
          },
          vertical = {
            prompt_position = "top",
            width_padding = 0.15,
            height_padding = 1,
            preview_height = 0,
          },
        },
      },
    }

    pcall(require("telescope").load_extension "projects")
    pcall(require("telescope").load_extension "fzf")
    pcall(require("telescope").load_extension "ui-select")
  end,
}
