-- debugger plugins
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-telescope/telescope-dap.nvim",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    require("dapui").setup()
    require("telescope").load_extension "dap"

    local dap = require "dap"

    dap.adapters.php = {
      type = "executable",
      command = "node",
      args = { os.getenv "HOME" .. "/.local/share/nvim/dap/php-debug/out/phpDebug.js" },
    }

    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug",
        port = 9003,
        -- pathMappings = {
        --   ["/Users/sheenazien8/Documents/Code/antikode"] = "${workspaceFolder}",
        -- },
      },
    }
  end,
}
