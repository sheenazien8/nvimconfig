local M = {}

-- Filter helper: only keep method & function symbols
-- TODO: still bug, not filtering the method only
local function filter_methods_and_functions(symbols)
  local filtered = {}

  local function handle_symbol(item)
    local kind = item.kind
    -- Filter ONLY methods + functions
    if kind == vim.lsp.protocol.SymbolKind.Method
      or kind == vim.lsp.protocol.SymbolKind.Function then
      table.insert(filtered, item)
    end
  end

  -- Handle hierarchical DocumentSymbol[]
  local function walk(items)
    for _, item in ipairs(items) do
      handle_symbol(item)

      -- DocumentSymbol with children
      if item.children then
        walk(item.children)
      end
    end
  end

  walk(symbols)
  return filtered
end

function M.LSPMethodsToQuickfix()
  vim.lsp.buf_request(
    0,
    "textDocument/documentSymbol",
    { textDocument = vim.lsp.util.make_text_document_params() },
    function(err, result)
      if err or not result then return end

      local filtered = filter_methods_and_functions(result)
      local items = vim.lsp.util.symbols_to_items(filtered, 0)

      vim.fn.setqflist({}, " ", {
        title = "LSP Methods",
        items = items,
      })

      vim.cmd("botright copen")
    end
  )
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
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

        -- Only map LSP functions if the server supports them
        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

        map("gs", M.LSPMethodsToQuickfix, "[G]oto [S]ymbols")

        map("grr", vim.lsp.buf.references, "[G]oto [R]eferences")

        map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

        -- Only map code action if the server supports it
        map("gra", vim.lsp.buf.code_action, "[C]ode [A]ction")

        map("K", vim.lsp.buf.hover, "Hover Documentation")

        -- map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        map("gri", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
          -- vim.bo[event.buf].formatexpr = nil
          -- vim.bo[event.buf].omnifunc = nil
          -- vim.keymap.del("n", "K", { buffer = event.buf })
        end
        -- require 'nvim_lsp'.ocamllsp.setup { on_attach = require 'virtualtypes'.on_attach }
      end,
    })

    local server_dir = vim.fn.stdpath "config" .. "/lua/custom/lspconfig/server" -- Adjust the path
    local handle
    if vim.fn.has "win32" == 1 then
      handle = io.popen('dir /b "' .. server_dir .. '"') -- Windows
    else
      handle = io.popen('ls -1 "' .. server_dir .. '"')  -- Linux/macOS
    end
    local servers = {}

    if handle then
      for filename in handle:lines() do
        if filename:match "%.lua$" then
          local module_name = "custom.lspconfig.server." .. filename:gsub("%.lua$", "")
          local success, server_config = pcall(require, module_name)
          if success and type(server_config) == "table" then
            servers[filename:gsub("%.lua$", "")] = server_config
          else
            print("Error loading server config file:", filename, server_config)
          end
        end
      end
      handle:close()
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "stylua", -- Used to format lua code
    })

    for lspname, server in pairs(servers) do
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
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      server.handlers = handlers
      vim.lsp.enable(lspname)
      vim.lsp.config(lspname, server)
    end
  end,
}
