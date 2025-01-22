return {
  "nvim-pack/nvim-spectre",
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    require("spectre").setup()

    vim.api.nvim_set_keymap("n", "<leader>sw", "<cmd>lua require('spectre').toggle()<CR>", { noremap = true })
  end,
}
