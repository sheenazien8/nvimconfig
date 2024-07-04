return {
  "numToStr/Comment.nvim",
  opts = {
    pre_hook = function(ctx)
      -- Use the existing ts_context_commentstring integration
      local pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
      local U = require "Comment.utils"

      -- Only calculate commentstring for Blade filetypes
      if vim.bo.filetype == "blade" then
        -- Determine whether to use linewise or blockwise comment
        local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

        -- Return the commentstring to use for Blade
        return require("Comment.ft").get("blade", type)
      end

      -- For other filetypes, use the existing pre_hook
      return pre_hook(ctx)
    end,
  },
  config = function(_, opts)
    require("Comment").setup(opts)
    require("Comment.ft").set("blade", { __default = "{{-- %s --}}", __multiline = "{{-- %s --}}" })
  end,
}
