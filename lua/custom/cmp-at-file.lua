local source = {}
source.__index = source

local file_cache = nil
local cache_cwd = nil

local function collect_files()
  local cwd = vim.fn.getcwd()
  if file_cache and cache_cwd == cwd then
    return file_cache
  end

  local files = {}

  if vim.fn.executable("fd") == 1 then
    files = vim.fn.systemlist("fd --type f --relative-path . 2>/dev/null")
  elseif vim.fn.isdirectory(cwd .. "/.git") == 1 then
    files = vim.fn.systemlist("git ls-files 2>/dev/null")
  else
    for _, f in ipairs(vim.fn.globpath(cwd, "**/*", 0, 1)) do
      if vim.fn.isdirectory(f) == 0 then
        table.insert(files, vim.fn.fnamemodify(f, ":."))
      end
    end
  end

  file_cache = files
  cache_cwd = cwd
  return files
end

local function score(path, query)
  if query == "" then
    return 0
  end

  local pl = path:lower()
  local ql = query:lower()
  local filename = vim.fn.fnamemodify(path, ":t"):lower()

  local s = 0

  if filename == ql then
    s = s + 200
  elseif filename:sub(1, #ql) == ql then
    s = s + 100
  elseif filename:find(ql, 1, true) then
    s = s + 60
  end

  if pl:find(ql, 1, true) then
    s = s + 40
  end

  local qi = 1
  local consecutive = 0
  for i = 1, #pl do
    if pl:sub(i, i) == ql:sub(qi, qi) then
      s = s + 5 + consecutive * 3
      consecutive = consecutive + 1
      qi = qi + 1
      if qi > #ql then
        break
      end
    else
      consecutive = 0
    end
  end

  if qi <= #ql then
    return -1
  end

  return s
end

function source.new()
  return setmetatable({}, source)
end

function source:get_trigger_characters()
  return { "@" }
end

function source:get_keyword_pattern()
  return [[@\S*]]
end

function source:complete(params, callback)
  local line = params.context.cursor_before_line
  local query = line:match("@([^%s]*)$")
  if query == nil then
    callback({ items = {} })
    return
  end

  local all_files = collect_files()
  local scored = {}

  for _, file in ipairs(all_files) do
    local s = score(file, query)
    if s >= 0 then
      table.insert(scored, { file = file, score = s })
    end
  end

  table.sort(scored, function(a, b)
    return a.score > b.score
  end)

  local items = {}
  for i = 1, math.min(#scored, 50) do
    local file = scored[i].file
    table.insert(items, {
      label = file,
      insertText = "@" .. file,
      filterText = "@" .. file,
      sortText = string.format("%05d", i),
      kind = vim.lsp.protocol.CompletionItemKind.File,
    })
  end

  callback({ items = items, isIncomplete = #scored > 50 })
end

return source
