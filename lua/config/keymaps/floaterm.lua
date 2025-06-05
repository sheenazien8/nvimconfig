return {
  enabled = false,
  n = {
    ["<leader>tn"] = { "<cmd>FloatermToggle<cr>", { desc = "Toggle Floaterm" } },
    ["<c-f>"] = { "<cmd>FloatermToggle<cr>", { desc = "Toggle Floaterm" } },
  },
  t = {
    ["<c-f>"] = { "<C-\\><C-n>:FloatermToggle<CR>", { desc = "Toggle Floaterm" } },
    ["<c-t>"] = { "<C-\\><C-n>:FloatermNew<CR>", { desc = "New Floaterm" } },
    ["<c-x>"] = { "<C-\\><C-n>:FloatermKill<CR>", { desc = "Kill Floaterm" } },
  },
}
