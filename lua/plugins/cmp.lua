return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
    },
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    'hrsh7th/cmp-cmdline',
    'tzachar/cmp-ai',
    "milanglacier/minuet-ai.nvim",
    "onsails/lspkind.nvim",
    "petertriho/cmp-git"
  },
  config = function()
    -- See `:help cmp`
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    require("luasnip/loaders/from_snipmate").lazy_load()
    luasnip.config.setup {}
    local has_words_before = function()
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match "^%s*$" == nil
    end

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = "menu,menuone,noinsert" },
      mapping = cmp.mapping.preset.insert {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif cmp.visible() and has_words_before() then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
            -- cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ['<C-x>'] = cmp.mapping(
          cmp.mapping.complete({
            config = {
              sources = cmp.config.sources({
                { name = 'cmp_ai' },
                { name = "copilot" },
                { name = "supermaven" },
                { name = "codeium" },
              }),
            },
          }),
          { 'i' }
        ),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        -- Select the [n]ext item
        ["<C-n>"] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ["<C-p>"] = cmp.mapping.select_prev_item(),

        ["<C-y>"] = cmp.mapping.confirm { select = true },
        ["<C-Space>"] = cmp.mapping.complete {},

        ["<C-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-u>'] = cmp.mapping.scroll_docs(4),
      },
      sources = {
        -- { name = "cmp_ai" },
        -- { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer" },
      },
      window = {
        -- completion = {
        --   winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        --   col_offset = -3,
        --   side_padding = 0,
        -- },
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local kind = require("lspkind").cmp_format {
            mode = "symbol_text",
            maxwidth = 50,
            symbol_map = {
              Codeium = "",
              Copilot = "",
              Codestral = "",
              OpenAI = "",
              Supermaven = "",
            },
          } (entry, vim_item)

          local strings = vim.split(kind.kind, "%s", { trimempty = true })
          kind.kind = " " .. (strings[1] or "") .. " "
          kind.menu = "    (" .. (strings[2] or "") .. ")"

          return kind
        end,
      },
    }

    cmp.setup.filetype({ "mysql", "sql" }, {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    })

    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'git' },
      }, {
        { name = 'buffer' },
      })
    })

    require("cmp_git").setup({})

    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      }),
      matching = { disallow_symbol_nonprefix_matching = false }
    })

    local lsp_util = vim.lsp.util

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = vim.api.nvim_create_augroup("code_action_sign", { clear = true }),
      callback = function()
        local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
        local params = lsp_util.make_range_params()
        params.context = context
        if vim.tbl_isempty(params.context.diagnostics) then
          return
        end
        vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, result, ctx, config)
          -- do something with result - e.g. check if empty and show some indication such as a sign
        end)
      end,
    })

    local cmp_ai = require('cmp_ai.config')

    cmp_ai:setup({
      max_lines = 1000,
      provider = 'Codestral',
      provider_options = {
        model = 'codestral-latest',
        prompt = function(lines_before, lines_after)
          return lines_before
        end,
        suffix = function(lines_after)
          return lines_after
        end
      },
      notify = false,
      notify_callback = function(msg)
        vim.notify(msg)
      end,
      run_on_every_keystroke = true,
    })

    cmp_ai:setup({
      max_lines = 1000,
      provider = 'OpenAI',
      provider_options = {
        model = 'gpt-4',
      },
      notify = true,
      notify_callback = function(msg)
        vim.notify(msg)
      end,
      run_on_every_keystroke = true,
      ignored_file_types = {
        -- default is not to ignore
        -- uncomment to ignore in lua:
        -- lua = true
      },
    })

    -- cmp_ai:setup({
    --   max_lines = 100,
    --   provider = 'Ollama',
    --   provider_options = {
    --     model = 'codegemma:2b-code',
    --     prompt = function(lines_before, lines_after)
    --       return lines_before
    --     end,
    --     suffix = function(lines_after)
    --       return lines_after
    --     end,
    --   },
    --   notify = true,
    --   notify_callback = function(msg)
    --     vim.notify(msg)
    --   end,
    --   run_on_every_keystroke = true,
    -- })
  end,
}
