return {
  n = {
    ["<leader>e"] = { vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" } },
    ["<leader>q"] = { vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" } },
    ["[d"] = { vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" } },
    ["]d"] = { vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" } },
  },
}
