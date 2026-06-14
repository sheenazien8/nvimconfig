local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("luares", {
    t { "> {%", "\t" },
    i(0),
    t { "", "\t%}" },
  }),

  s("luaq", {
    t { "> {%", "local json = vim.json.decode(response.body)", "", "local output = vim.fn.system(" },
    t { "\t{ \"jq\", '" },
    i(1, "."),
    t "' },",
    t { "", "\tresponse.body", ")" },
    t { "", "response.body = output", "%}" },
  }),

  s("luapre", {
    t { "< {%", "\t" },
    i(0),
    t { "", "\t%}" },
  }),

  s("luajson", {
    t { "> {%", "local json = vim.json.decode(response.body)", "vim.print(json)", "\t" },
    t { "> {%", "local json = vim.json.decode(response.body)", "vim.print(json)", "\t" },
    i(0),
    t { "\t%}" },
  }),

  s("luaenv", {
    t { "> {%", "local json = vim.json.decode(response.body)", "ix.env.set(" },
    t { '"', "" },
    i(1, "var"),
    t { '", json.' },
    i(2, "data"),
    t { ")", "%}" },
  }),

  s("httpget", {
    t "GET ",
    i(1, "https://example.com/api"),
    t { "", "" },
    i(0),
  }),

  s("httppost", {
    t "POST ",
    i(1, "https://example.com/api"),
    t { "", "Content-Type: application/json", "", "{" },
    t { "", "\t" },
    i(0),
    t { "", "}" },
  }),
}
