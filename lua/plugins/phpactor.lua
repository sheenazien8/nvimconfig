return {
  "gbprod/phpactor.nvim",
  build = function()
    require "phpactor.handler.update"()
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function(opts)
    require("phpactor").setup {
      lspconfig = {
        enabled = false,
        options = {},
      },
    }
    vim.keymap.set("n", "<leader>pn", ":PhpActor navigate<CR>")
    vim.keymap.set("n", "<leader>pc", ":PhpActor context_menu<CR>")
    vim.keymap.set("n", "<leader>pt", ":PhpActor transform<CR>")
  end,
}
