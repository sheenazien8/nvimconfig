local builtin = require "telescope.builtin"

return {
  n = {
    ["<leader>sh"] = { builtin.help_tags, { desc = "[S]earch [H]elp" } },
    ["<leader>sk"] = { builtin.keymaps, { desc = "[S]earch [K]eymaps" } },
    ["<leader>sf"] = { builtin.find_files, { desc = "[S]earch [F]iles" } },
    ["<c-p>"] = { builtin.find_files, { desc = "[S]earch [F]iles (no prompt)" } },
    ["<leader>ss"] = { builtin.builtin, { desc = "[S]earch [S]elect Telescope" } },
    ["<leader>sg"] = { builtin.live_grep, { desc = "[S]earch by [G]rep" } },
    ["<leader>sd"] = { builtin.diagnostics, { desc = "[S]earch [D]iagnostics" } },
    ["<leader>sr"] = { builtin.resume, { desc = "[S]earch [R]esume" } },
    ["<leader>s."] = { builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' } },
    ["<leader>sb"] = { builtin.buffers, { desc = "[ ] Find existing buffers" } },
    ["<c-n>"] = { builtin.buffers, { desc = "[ ] Find existing buffers" } },
    ["<leader>/"] = {
      function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end,
      { desc = "[/] Fuzzily search in current buffer" },
    },
    ["<leader>s/"] = {
      function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        }
      end,
      { desc = "[S]earch [/] in Open Files" },
    },
    ["<leader>sn"] = {
      function()
        builtin.find_files { cwd = vim.fn.stdpath "config" }
      end,
      { desc = "[S]earch [N]eovim files" },
    },
    ["<leader>sp"] = {
      function()
        require("telescope").extensions.projects.projects {}
      end,
      { desc = "[S]earch [P]rojects" },
    },
  },
}
