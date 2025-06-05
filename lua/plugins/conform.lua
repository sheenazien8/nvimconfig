-- plugins for handling formatting code
return {
  "stevearc/conform.nvim",
  opts = {
    notify_on_error = false,
    -- format_on_save = {
    --   timeout_ms = 500,
    --   lsp_fallback = true,
    -- },
    format_on_save = false,
    formatters_by_ft = {
      lua = { "stylua" },
      php = { "pint" },
      blade = { "blade-formatter" },
    }
  },
}
