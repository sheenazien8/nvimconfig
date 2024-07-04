return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "V13Axel/neotest-pest",
    "olimorris/neotest-phpunit",
    "nvim-neotest/neotest-jest",
  },
  config = function()
    require("neotest").setup {
      adapters = {
        require "neotest-pest" {
          ignore_dirs = { "vendor", "node_modules" },
          root_ignore_files = { "phpunit-only.tests" },
          test_file_suffixes = { "Test.php", "_test.php", "PestTest.php" },
          sail_enabled = function()
            return false
          end,
          sail_executable = "vendor/bin/sail",
          sail_project_path = "/var/www/html",
          pest_cmd = "vendor/bin/pest",
          parallel = 16,
          compact = false,
        },
        require "neotest-jest" {
          jestCommand = "npm run test:e2e",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        },
        -- require("neotest-phpunit"),
      },
    }
    vim.keymap.set("n", "<leader>nt", "<cmd>lua require('neotest').run.run()<CR>")
    vim.keymap.set("n", "<leader>ns", "<cmd>Neotest summary<CR>")
  end,
}
