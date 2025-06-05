-- plugins for icons circles
return {
  "projekt0n/circles.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("circles").setup {
      lsp = true,
    }
  end,
}
