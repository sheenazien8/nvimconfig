-- flutter tools
return {
	"akinsho/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim", -- optional for vim.ui.select
	},
	config = function()
		require("flutter-tools").setup({})
		require("telescope").load_extension("flutter")
		vim.keymap.set("n", "<leader>tf", "<cmd>Telescope flutter commands<CR>", { desc = "[S]earch [H]elp" })
	end,
}
