local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function title_from_filename()
  local name = vim.fn.expand "%:t:r"
  if name == "" then
    return "Title"
  end
  return name:gsub("[%-_]", " "):gsub("(%a)([%w]*)", function(first, rest)
    return first:upper() .. rest
  end)
end

return {
  s("task", {
    t "# ",
    f(title_from_filename, {}),
    t { "", "", "## Context", "- files: " },
    i(1, "@path/to/file"),
    t { "", "- " },
    i(2, "describe the current state"),
    t { "", "", "## Goals", "- " },
    i(3, "what needs to be done"),
    t { "", "", "## Notes", "- " },
    i(4, "Deep analyze the context base on the completed tasks"),
    t { "", "", "## Tools / Skills", "- " },
    i(5, "mcp database / tools"),
    t { "", "", "## Implementation", "<!-- Write you've done in here -->", "" },
    i(0),
  }),
}
