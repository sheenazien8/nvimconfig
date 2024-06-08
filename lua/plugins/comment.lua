return {
  "numToStr/Comment.nvim",
  opts = {
    pre_hook = function(ctx)
      -- Use the existing ts_context_commentstring integration
      local pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()

      -- Only calculate commentstring for Blade filetypes
      if vim.bo.filetype == "blade" then
        local U = require "Comment.utils"

        -- Determine whether to use linewise or blockwise commentstring
        local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"

        -- Calculate the commentstring
        local location = nil
        if ctx.ctype == U.ctype.block then
          location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
          location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        return require("ts_context_commentstring.internal").calculate_commentstring {
          key = type,
          location = location,
        }
      end

      -- For other filetypes, use the existing pre_hook
      return pre_hook(ctx)
    end,
  },
  config = function(_, opts)
    require("Comment").setup(opts)
  end,
}
