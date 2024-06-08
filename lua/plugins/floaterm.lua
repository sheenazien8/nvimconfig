return {
	"voldikss/vim-floaterm",
	config = function()
		vim.g.floaterm_width = 0.8
		vim.g.floaterm_height = 0.8
		vim.keymap.set("n", "<c-t>", ":FloatermToggle<CR>")
		vim.keymap.set("t", "<c-t>", "<C-\\><C-n>:FloatermToggle<CR>")
		vim.cmd([[
      highlight link Floaterm CursorLine
      highlight link FloatermBorder CursorLineBg
    ]])
	end,
}
