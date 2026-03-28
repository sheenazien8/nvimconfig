-- github copilot
return {
  {
    enabled = true,
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    enabled = true,
    commit = "2b368ce",
    event = { "InsertEnter", "LspAttach" },
    fix_pairs = true,
    requires = {
      "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
    },
    config = function()
      require("copilot").setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
        settings = {
          advanced = {
            listCount = 10,     -- #completions for panel
            inlineSuggestCount = 3, -- #completions for getCompletions
          }
        },
      }
    end,
  }
}
