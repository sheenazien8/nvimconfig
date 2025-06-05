return {
  i = {
    ["jk"] = { "<ESC>", { noremap = true, desc = "Escape to Normal mode" } },
    ["kj"] = { "<ESC>", { noremap = true, desc = "Escape to Normal mode" } },
    ["jj"] = { "<ESC>", { noremap = true, desc = "Escape to Normal mode" } },
    ["jl"] = { "<ESC>", { noremap = true, desc = "Escape to Normal mode" } },
  },
  n = {
    ["<ESC>"] = { "<cmd>nohlsearch<CR>", { desc = "clear search highlight" } },
    ["<leader><leader>"] = { "<cmd>nohlsearch<CR>", { desc = "clear search highlight" } },
    ["<leader>vp"] = { "<cmd>VimuxTogglePane<CR>", { noremap = true, desc = "Toggle Vimux pane" } },
    ["<leader>vt"] = {
      function()
        local command = vim.fn.input "Command: "
        vim.fn.VimuxRunCommand(command)
      end,
      { noremap = true, desc = "Run command in Vimux" },
    },
    -- ["<C-r>"] = { "<cmd>OpenRoutesFile<CR>", { noremap = true, desc = "Open routes file" } },
    ["s"] = { "<Plug>(leap)", { desc = "Leap forward to the next match" } },
    ["<leader>hrc"] = { "<cmd>Http run_closest<CR>", { desc = "Run closest http" } },
    ["<leader>hrl"] = { "<cmd>Http run_last<CR>", { desc = "Run last http" } },
  },
  t = {
    ["<Esc><Esc>"] = { "<C-\\><C-n>", { desc = "Exit terminal mode" } },
  },
}
