return {
  n = {
    ["<leader>qs"] = {
      function()
        require("persistence").load()
      end,
      { desc = "Restore Session" },
    },
  },
}
