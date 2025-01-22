return { -- Autoformat
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
      -- blade = { "blade-formatter" },
    },
  },
  config = function(opts)
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
    vim.keymap.set('n', '<c-s>', '<cmd>Format<CR>')
    vim.keymap.set('i', '<c-s>', '<cmd>Format<CR>')
  end
}
