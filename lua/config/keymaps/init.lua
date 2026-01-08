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
    ["f"] = { "<Plug>(leap)", { desc = "Leap forward to the next match" } },
    ["<c-t>"] = { "<cmd>hori Rest run<CR>", { desc = "Run closest http" } },
    ["<c-z>"] = { "<cmd>hori Rest last<CR>", { desc = "Run last http" } },
    ["<leader>tn"] = { "<cmd>tabnext<CR>", { desc = "Go to next tab" } },
    ["<leader>tp"] = { "<cmd>tabprev<CR>", { desc = "Go to previous tab" } },
    ["<leader>tc"] = { "<cmd>tabnew<CR>", { desc = "Create new tab" } },
    ["-"] = { "<CMD>Oil<CR>", { desc = "Oil" } },
    ["<leader>te"] = { "<CMD>Telescope rest select_env<CR>", { desc = "Select env", pattern = { "http" } } },
  },
  t = {
    ["<Esc><Esc>"] = { "<C-\\><C-n>", { desc = "Exit terminal mode" } },
  },
}
