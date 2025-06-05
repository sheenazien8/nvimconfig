-- worktree is for handling git command in simply way
return {
  "ThePrimeagen/git-worktree.nvim",
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = true
}
