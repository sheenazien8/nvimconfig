-- vim.keymap.set("n", "<F5>", function()
--   require("dap").continue()
-- end)
-- vim.keymap.set("n", "<F10>", function()
--   require("dap").step_over()
-- end)
-- vim.keymap.set("n", "<F11>", function()
--   require("dap").step_into()
-- end)
-- vim.keymap.set("n", "<F12>", function()
--   require("dap").step_out()
-- end)
-- vim.keymap.set("n", "<Leader>b", function()
--   require("dap").toggle_breakpoint()
-- end)
-- vim.keymap.set("n", "<Leader>B", function()
--   require("dap").set_breakpoint()
-- end)
-- vim.keymap.set("n", "<Leader>lp", function()
--   require("dap").set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
-- end)
-- vim.keymap.set("n", "<Leader>dr", function()
--   require("dap").repl.open()
-- end)
-- vim.keymap.set("n", "<Leader>dl", function()
--   require("dap").run_last()
-- end)
-- vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
--   require("dap.ui.widgets").hover()
-- end)
-- vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
--   require("dap.ui.widgets").preview()
-- end)
-- vim.keymap.set("n", "<Leader>df", function()
--   local widgets = require "dap.ui.widgets"
--   widgets.centered_float(widgets.frames)
-- end)
-- vim.keymap.set("n", "<Leader>ds", function()
--   local widgets = require "dap.ui.widgets"
--   widgets.centered_float(widgets.scopes)
-- end)

return {
  n = {
    -- ["<leader>tn"] = { "<cmd>FloatermToggle<cr>", { desc = "Toggle Floaterm" } },
    ["<leader>dc"] = { "<cmd>lua require('dap').continue()<cr>", { desc = "Continue" } },
    ["<leader>do"] = { "<cmd>lua require('dap').step_over()<cr>", { desc = "Step Over" } },
    ["<leader>di"] = { "<cmd>lua require('dap').step_into()<cr>", { desc = "Step Into" } },
    ["<leader>so"] = { "<cmd>lua require('dap').step_out()<cr>", { desc = "Step Out" } },
    ["<leader>b"] = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", { desc = "Toggle Breakpoint" } },
    ["<leader>B"] = { "<cmd>lua require('dap').set_breakpoint()<cr>", { desc = "Set Breakpoint" } },
    ["<leader>lp"] = {
      "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
      { desc = "Set Log Point" },
    },
    ["<leader>dr"] = { "<cmd>lua require('dap').repl.open()<cr>", { desc = "Open REPL" } },
    ["<leader>dl"] = { "<cmd>lua require('dap').run_last()<cr>", { desc = "Run Last" } },
    ["<leader>dh"] = { "<cmd>lua require('dap.ui.widgets').hover()<cr>", { desc = "Hover" } },
    ["<leader>dp"] = { "<cmd>lua require('dap.ui.widgets').preview()<cr>", { desc = "Preview" } },
    ["<leader>df"] = {
      "<cmd>lua local widgets = require('dap.ui.widgets'); widgets.centered_float(widgets.frames)<cr>",
      { desc = "Frames" },
    },
    ["<leader>ds"] = {
      "<cmd>lua local widgets = require('dap.ui.widgets'); widgets.centered_float(widgets.scopes)<cr>",
      { desc = "Scopes" },
    },
  },
}
