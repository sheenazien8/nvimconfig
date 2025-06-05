-- plugin for AI autocompletion github replacement
return {
  "Exafunction/codeium.nvim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("codeium").setup {
      enable_chat = false,
    }
  end,
}
