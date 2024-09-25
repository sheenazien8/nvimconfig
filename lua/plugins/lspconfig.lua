return { -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    { "j-hui/fidget.nvim", opts = {} },

    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

        map("K", vim.lsp.buf.hover, "Hover Documentation")

        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    local lspconfig = require "lspconfig"
    local configs = require "lspconfig.configs"
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    local util = require "lspconfig.util"

    -- local server_name = "intelephense"
    local bin_name = "intelephense"
    local servers = {
      intelephense = {
        cmd = { bin_name, "--stdio" },
        filetypes = { "php", "blade" },
        root_dir = function(pattern)
          local cwd = vim.loop.cwd()
          local root = util.root_pattern("composer.json", ".git")(pattern)

          -- prefer cwd if root is a descendant
          return util.path.is_descendant(cwd, root) and cwd or root
        end,
        init_options = {
          licenceKey = "000CKL0DIXLFA4U",
        },
        settings = {
          intelephense = {
            files = {
              maxSize = 1000000,
            },
          },
        },
      },
      lua_ls = {
        -- cmd = {...},
        -- filetypes { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            diagnostics = { disable = { "missing-fields" }, globals = { "vim" } },
          },
        },
      },
      ts_ls = {},
      html = {
        filetypes = { "html", "templ", "blade" },
        init_options = {
          provideFormatter = false,
        },
      },
      -- phpactor = {},
    }
    -- Configure it
    configs.blade = {
      default_config = {
        -- Path to the executable: laravel-dev-generators
        cmd = { vim.fn.expand "$HOME/Documents/apps/laravel-dev-tools/builds/laravel-dev-tools", "lsp" },
        filetypes = { "blade" },
        root_dir = function(fname)
          return lspconfig.util.find_git_ancestor(fname)
        end,
        settings = {},
      },
    }

    -- Set it up
    lspconfig.blade.setup {
      -- Capabilities is specific to my setup.
      capabilities = capabilities,
    }
    vim.lsp.util.apply_text_document_edit = function(text_document_edit, index, offset_encoding)
      local text_document = text_document_edit.textDocument
      local bufnr = vim.uri_to_bufnr(text_document.uri)
      if offset_encoding == nil then
        vim.notify_once("apply_text_document_edit must be called with valid offset encoding", vim.log.levels.WARN)
      end

      vim.lsp.util.apply_text_edits(text_document_edit.edits, bufnr, offset_encoding)
    end

    require("mason").setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "stylua", -- Used to format lua code
    })

    require("mason-tool-installer").setup { ensure_installed = ensure_installed }

    require("mason-lspconfig").setup {
      handlers = {
        function(server_name)
          vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
          vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

          local border = {
            { "🭽", "FloatBorder" },
            { "▔", "FloatBorder" },
            { "🭾", "FloatBorder" },
            { "▕", "FloatBorder" },
            { "🭿", "FloatBorder" },
            { "▁", "FloatBorder" },
            { "🭼", "FloatBorder" },
            { "▏", "FloatBorder" },
          }

          local handlers = {
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
          }

          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          server.handlers = handlers
          require("lspconfig")[server_name].setup(server)
        end,
      },
    }
  end,
}
