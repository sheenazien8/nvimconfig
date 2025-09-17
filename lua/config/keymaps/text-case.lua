-- Text case conversion functions and keymaps for visual mode

local M = {}

-- Convert text to camelCase
local function to_camel_case(text)
  -- Split by non-alphanumeric characters and convert
  local words = {}
  for word in text:gmatch "[%w]+" do
    table.insert(words, word:lower())
  end
  
  if #words == 0 then
    return text
  end
  
  -- First word lowercase, rest title case
  local result = words[1]
  for i = 2, #words do
    result = result .. words[i]:sub(1, 1):upper() .. words[i]:sub(2)
  end
  
  return result
end

-- Convert text to PascalCase
local function to_pascal_case(text)
  local words = {}
  for word in text:gmatch "[%w]+" do
    table.insert(words, word:lower())
  end
  
  if #words == 0 then
    return text
  end
  
  -- All words title case
  local result = ""
  for _, word in ipairs(words) do
    result = result .. word:sub(1, 1):upper() .. word:sub(2)
  end
  
  return result
end

-- Convert text to snake_case
local function to_snake_case(text)
  local words = {}
  for word in text:gmatch "[%w]+" do
    table.insert(words, word:lower())
  end
  
  return table.concat(words, "_")
end

-- Convert text to Title Case
local function to_title_case(text)
  local words = {}
  for word in text:gmatch "[%w]+" do
    local title_word = word:sub(1, 1):upper() .. word:sub(2):lower()
    table.insert(words, title_word)
  end
  
  return table.concat(words, " ")
end

-- Generic function to apply case conversion to visual selection
local function apply_case_conversion(convert_func)
  -- Get visual selection
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  
  local start_row, start_col = start_pos[2], start_pos[3]
  local end_row, end_col = end_pos[2], end_pos[3]
  
  -- Get selected text
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  
  if #lines == 0 then
    return
  end
  
  -- Handle single line selection
  if #lines == 1 then
    local line = lines[1]
    local selected_text = line:sub(start_col, end_col)
    local converted_text = convert_func(selected_text)
    
    -- Replace the selected text
    local new_line = line:sub(1, start_col - 1) .. converted_text .. line:sub(end_col + 1)
    vim.api.nvim_buf_set_lines(0, start_row - 1, start_row, false, { new_line })
  else
    -- Handle multi-line selection
    local selected_text = ""
    
    -- First line
    selected_text = selected_text .. lines[1]:sub(start_col) .. "\n"
    
    -- Middle lines
    for i = 2, #lines - 1 do
      selected_text = selected_text .. lines[i] .. "\n"
    end
    
    -- Last line
    selected_text = selected_text .. lines[#lines]:sub(1, end_col)
    
    local converted_text = convert_func(selected_text)
    local converted_lines = vim.split(converted_text, "\n")
    
    -- Replace the selected lines
    vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, converted_lines)
  end
end

-- Export keymaps for visual mode
return {
  v = {
    ["<leader>cc"] = {
      function()
        apply_case_conversion(to_camel_case)
      end,
      { desc = "Convert to camelCase" },
    },
    ["<leader>cp"] = {
      function()
        apply_case_conversion(to_pascal_case)
      end,
      { desc = "Convert to PascalCase" },
    },
    ["<leader>cs"] = {
      function()
        apply_case_conversion(to_snake_case)
      end,
      { desc = "Convert to snake_case" },
    },
    ["<leader>ct"] = {
      function()
        apply_case_conversion(to_title_case)
      end,
      { desc = "Convert to Title Case" },
    },
  },
}