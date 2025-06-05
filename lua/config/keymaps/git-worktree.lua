require("telescope").load_extension "git_worktree"

-- HACK: by default
-- <Enter> - switches to that worktree
-- <c-d> - deletes that worktree
-- <c-f> - toggles forcing of the next deletion

-- Create new worktree
-- vim.keymap.set("n", "<leader>wl", function()
--   require("telescope").extensions.git_worktree.git_worktrees()
-- end, { desc = "list Git Worktree" })
--
-- -- Switch/list worktrees
-- vim.keymap.set("n", "<leader>wc", function()
--   require("telescope").extensions.git_worktree.create_git_worktree()
-- end, { desc = "Create Git Worktree Branches" })

return {
  n = {
    ["<leader>wl"] = {
      function()
        require("telescope").extensions.git_worktree.git_worktrees()
      end,
      { desc = "list Git Worktree" },
    },
    ["<leader>wc"] = {
      function()
        require("telescope").extensions.git_worktree.create_git_worktree()
      end,
      { desc = "Create Git Worktree Branches" },
    },
  },
}
