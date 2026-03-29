local env = require "config.env"

-- plugins for handling formatting code
return {
  "stevearc/conform.nvim",
  enabled = not env.is_server,
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
      sql = { "sql_formatter" },
      mysql = { "sql_formatter" },
      plsql = { "sql_formatter" },
    }
  },
}
