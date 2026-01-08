-- ~/.config/nvim/lua/json_collection/init.lua

local Collection = {}
Collection.__index = Collection

-- Helper: shallow copy array
local function copy_array(tbl)
  local out = {}
  for i, v in ipairs(tbl) do
    out[i] = v
  end
  return out
end

-- Constructor
function Collection.new(items)
  items = items or {}
  return setmetatable({ _items = items }, Collection)
end

-- Allow calling like Collection(tbl)
setmetatable(Collection, {
  __call = function(_, items)
    return Collection.new(items)
  end,
})

-- Create from JSON string (Neovim)
function Collection.from_json(json_str)
  local ok, parsed = pcall(vim.json.decode, json_str)
  if not ok then
    error("Invalid JSON: " .. tostring(parsed))
  end
  return Collection.new(parsed)
end

-- Return raw Lua table
function Collection:all()
  return self._items
end

-- Count items
function Collection:count()
  return #self._items
end

-- map(fn(item, index)) -> Collection
function Collection:map(fn)
  local mapped = {}
  for i, v in ipairs(self._items) do
    mapped[i] = fn(v, i)
  end
  return Collection.new(mapped)
end

-- filter(fn(item, index) -> bool) -> Collection
function Collection:filter(fn)
  local filtered = {}
  local idx = 1
  for i, v in ipairs(self._items) do
    if fn(v, i) then
      filtered[idx] = v
      idx = idx + 1
    end
  end
  return Collection.new(filtered)
end

-- where("key", value) -> Collection (like Laravel)
function Collection:where(key, value)
  return self:filter(function(item)
    return type(item) == "table" and item[key] == value
  end)
end

-- pluck("id") -> Collection of values
-- e.g. [{id=1},{id=2}] => [1,2]
function Collection:pluck(key)
  local out = {}
  for i, v in ipairs(self._items) do
    if type(v) == "table" then
      out[i] = v[key]
    else
      out[i] = nil
    end
  end
  return Collection.new(out)
end

-- pluck_many({ "id", "name" }) -> Collection of tables
-- e.g. [{id=1,name="a"}] => [ {id=1,name="a"} ]
function Collection:pluck_many(keys)
  local out = {}
  for i, v in ipairs(self._items) do
    if type(v) == "table" then
      local picked = {}
      for _, key in ipairs(keys) do
        picked[key] = v[key]
      end
      out[i] = picked
    end
  end
  return Collection.new(out)
end

-- reduce(fn(acc, item, index), initial?)
function Collection:reduce(fn, initial)
  local acc = initial
  local start = 1

  if acc == nil then
    acc = self._items[1]
    start = 2
  end

  for i = start, #self._items do
    acc = fn(acc, self._items[i], i)
  end

  return acc
end

-- first([fn]) -> item or nil
function Collection:first(fn)
  if not fn then
    return self._items[1]
  end

  for i, v in ipairs(self._items) do
    if fn(v, i) then
      return v
    end
  end
  return nil
end

-- last() -> item or nil
function Collection:last()
  return self._items[#self._items]
end

-- sortBy("key", [desc]) -> Collection
function Collection:sortBy(key, desc)
  local items = copy_array(self._items)
  table.sort(items, function(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
      return false
    end
    local va = a[key]
    local vb = b[key]
    if desc then
      return va > vb
    else
      return va < vb
    end
  end)
  return Collection.new(items)
end

-- each(fn) -> self (for side effects)
function Collection:each(fn)
  for i, v in ipairs(self._items) do
    fn(v, i)
  end
  return self
end

-- keys() -> Collection of keys (for map-like tables)
function Collection:keys()
  local out = {}
  local i = 1
  for k, _ in pairs(self._items) do
    out[i] = k
    i = i + 1
  end
  return Collection.new(out)
end

-- values() -> Collection of values (for map-like tables)
function Collection:values()
  local out = {}
  local i = 1
  for _, v in pairs(self._items) do
    out[i] = v
    i = i + 1
  end
  return Collection.new(out)
end

-- Simple pretty dump using vim.inspect if available
function Collection:dump()
  if vim and vim.inspect then
    print(vim.inspect(self._items))
  else
    -- fallback minimal
    print(tostring(self))
  end
  return self
end

function Collection:__tostring()
  if vim and vim.inspect then
    return vim.inspect(self._items)
  end
  return "<Collection: " .. tostring(#self._items) .. " items>"
end

return Collection
