return {
  "ahmedkhalf/project.nvim",
  enabled = true,
  config = function()
    require("project_nvim").setup {
      manual_mode = true,
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end,
}
