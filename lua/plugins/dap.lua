return {
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  'theHamsta/nvim-dap-virtual-text',
  'nvim-telescope/telescope-dap.nvim',
  config = function()
    require('dapui').setup()
    require('telescope').load_extension('dap')

    local dap = require('dap')

    dap.adapters.php = {
      type = 'executable',
      command = 'node',
      args = { os.getenv("HOME") .. '/Documents/apps/vscode-php-debug/out/phpDebug.js' }
    }

    dap.configurations.php = {
      {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 9003,
        pathMappings = {
          ["/var/www/html"] = "${workspaceFolder}"
        }
      }
    }
  end
}
