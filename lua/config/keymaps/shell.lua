return {
  n = {
    ["<leader>rs"] = { "<cmd>lua require('custom.auto_run_sh').run_sh()<CR>", { desc = "Run shell script" } },
  },
}