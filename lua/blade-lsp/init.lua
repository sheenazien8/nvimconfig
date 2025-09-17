local M = {}

function M.setup(opts)
  local lspconfig = require('lspconfig')
  local configs = require('lspconfig.configs')
  if not configs.blade_lsp then
    configs.blade_lsp = {
      default_config = {
        cmd = opts.cmd or { 'blade-lsp' },
        filetypes = opts.filetypes or { 'blade' },
        root_dir = opts.root_dir or lspconfig.util.root_pattern('.git', 'composer.json'),
        settings = opts.settings or {},
        init_options = opts.init_options or {},
      },
      docs = {
        description = 'Blade LSP server for Laravel Blade templates',
      },
    }
  end
  lspconfig.blade_lsp.setup(opts.lsp_config or {})
end

return M

