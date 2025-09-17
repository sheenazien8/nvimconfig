-- github copilot
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  enabled = true,
  event = "InsertEnter",
  config = function()
    require("copilot").setup {
      suggestion = { enabled = false },
      panel = { enabled = false },
    }
  end,
}
