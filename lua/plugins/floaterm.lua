return {
  "voldikss/vim-floaterm",
  enabled = false,
  config = function()
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8
    vim.keymap.set("n", "<c-f>", ":FloatermToggle<CR>")
    vim.keymap.set("n", "<leader>tn", ":FloatermToggle<CR>")
    vim.keymap.set("t", "<c-f>", "<C-\\><C-n>:FloatermToggle<CR>")
    vim.keymap.set("t", "<c-t>", "<C-\\><C-n>:FloatermNew<CR>")
    -- vim.keymap.set("t", "<c-p>", "<C-\\><C-n>:FloatermPrev<CR>")
    vim.keymap.set("t", "<c-x>", "<C-\\><C-n>:FloatermKill<CR>")
    vim.cmd [[
      highlight link Floaterm CursorLine
      highlight link FloatermBorder CursorLineBg
    ]]
  end,
}
