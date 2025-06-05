require "init"

local buf = nil

local function open_todo_sidebar()
  local todo_path = vim.fn.getcwd() .. "/todo.md"

  if vim.fn.filereadable(todo_path) == 0 then
    vim.notify("todo.md not found in current project", vim.log.levels.WARN)
    return
  end

  -- Create a new scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Read todo.md content
  vim.fn.jobstart({ "cat", todo_path }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
      end
    end,
  })

  -- Get UI dimensions
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.25)  -- 25% width
  local height = ui.height
  local row = 0
  local col = 0

  -- Create floating sidebar window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- Buffer options
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_option(buf, "wrap", true)

  -- Save on close
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    callback = function()
      vim.fn.writefile(vim.api.nvim_buf_get_lines(buf, 0, -1, false), todo_path)
    end,
  })

  -- Keymap: 'q' to close
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true, silent = true, desc = "Close todo sidebar" })

  -- Keymap: <leader>tc to toggle checkbox
  vim.keymap.set("n", "<leader>tc", function()
    local line = vim.api.nvim_get_current_line()
    local new_line = line

    if line:match("%[ %]") then
      new_line = line:gsub("%[ %]", "[x]", 1)
    elseif line:match("%[x%]") then
      new_line = line:gsub("%[x%]", "[ ]", 1)
    end

    if new_line ~= line then
      local row = vim.api.nvim_win_get_cursor(0)[1] - 1
      vim.api.nvim_buf_set_lines(buf, row, row + 1, false, { new_line })
    end
  end, { buffer = buf, nowait = true, silent = true, desc = "Toggle checkbox" })
end

-- Map <leader>tt to open the sidebar
vim.keymap.set("n", "<leader>tt", open_todo_sidebar, { desc = "Open todo.md as sidebar" })


local function open_todo_floating()
  local todo_path = vim.fn.getcwd() .. "/todo.md"

  if vim.fn.filereadable(todo_path) == 0 then
    vim.notify("todo.md not found in current project", vim.log.levels.WARN)
    return
  end

  -- Create a new scratch buffer
  buf = vim.api.nvim_create_buf(false, true)

  -- Read todo.md content into the buffer
  vim.fn.jobstart({ "cat", todo_path }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
      end
    end,
  })

  -- Calculate floating window size and position
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.7)
  local height = math.floor(ui.height * 0.7)
  local row = math.floor((ui.height - height) / 2)
  local col = math.floor((ui.width - width) / 2)

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- Buffer settings
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_option(buf, "wrap", false)

  -- Close window and save on buffer wipeout
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    callback = function()
      vim.fn.writefile(vim.api.nvim_buf_get_lines(buf, 0, -1, false), todo_path)
    end,
  })

  -- Add local keymap to quit with 'q'
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true, silent = true, desc = "Close todo floating window" })
end

-- Keymap: <leader>tt to open the floating todo.md
vim.keymap.set("n", "<leader>tt", open_todo_floating, { desc = "Open todo.md in floating window" })

-- inside open_todo_floating()

-- Define local function inside this scope so it's tied to the buffer
local function toggle_checkbox()
  local line = vim.api.nvim_get_current_line()
  local new_line = line

  if line:match("%[ %]") then
    new_line = line:gsub("%[ %]", "[x]", 1)
  elseif line:match("%[x%]") then
    new_line = line:gsub("%[x%]", "[ ]", 1)
  end

  if new_line ~= line then
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    vim.api.nvim_buf_set_lines(buf, row, row + 1, false, { new_line })
  end
end

-- Map <leader>tc inside this buffer
vim.keymap.set("n", "<leader>tc", toggle_checkbox, {
  buffer = buf,
  desc = "Toggle checkbox in todo.md",
  nowait = true,
  silent = true,
})

