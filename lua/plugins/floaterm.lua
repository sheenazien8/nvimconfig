-- show terminal in floating window
return {
  "voldikss/vim-floaterm",
  enabled = false,
  config = function()
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8
    vim.cmd [[
      highlight link Floaterm CursorLine
      highlight link FloatermBorder CursorLineBg
    ]]
  end,
}
