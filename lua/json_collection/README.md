# JSON Collection

A Laravel-inspired Collection library for Lua/Neovim that provides fluent, chainable methods for working with arrays and JSON data.

## Installation

```lua
local Collection = require "json_collection"
```

## Creating Collections

```lua
-- From a Lua table
local c = Collection.new({ 1, 2, 3, 4, 5 })

-- Using shorthand syntax
local c = Collection({ 1, 2, 3, 4, 5 })

-- From JSON string (Neovim only)
local c = Collection.from_json('[{"id": 1, "name": "John"}, {"id": 2, "name": "Jane"}]')
```

## Available Methods

### `all()`

Returns the raw Lua table.

```lua
Collection({ 1, 2, 3 }):all()  -- { 1, 2, 3 }
```

### `count()`

Returns the number of items.

```lua
Collection({ 1, 2, 3 }):count()  -- 3
```

### `map(fn)`

Transforms each item using the callback.

```lua
Collection({ 1, 2, 3 }):map(function(item) return item * 2 end):all()
-- { 2, 4, 6 }
```

### `filter(fn)`

Filters items based on a callback.

```lua
Collection({ 1, 2, 3, 4 }):filter(function(item) return item > 2 end):all()
-- { 3, 4 }
```

### `where(key, value)`

Filters objects where `key` equals `value`.

```lua
local users = Collection({
  { id = 1, role = "admin" },
  { id = 2, role = "user" },
  { id = 3, role = "admin" },
})
users:where("role", "admin"):all()
-- { { id = 1, role = "admin" }, { id = 3, role = "admin" } }
```

### `pluck(key)`

Extracts a single field from each object.

```lua
local users = Collection({ { id = 1, name = "John" }, { id = 2, name = "Jane" } })
users:pluck("name"):all()  -- { "John", "Jane" }
```

### `pluck_many(keys)`

Extracts multiple fields from each object.

```lua
local users = Collection({ { id = 1, name = "John", age = 30 } })
users:pluck_many({ "id", "name" }):all()
-- { { id = 1, name = "John" } }
```

### `reduce(fn, initial)`

Reduces the collection to a single value.

```lua
Collection({ 1, 2, 3, 4 }):reduce(function(acc, item) return acc + item end, 0)
-- 10
```

### `first([fn])`

Returns the first item, or first matching a callback.

```lua
Collection({ 1, 2, 3 }):first()  -- 1
Collection({ 1, 2, 3 }):first(function(item) return item > 1 end)  -- 2
```

### `last()`

Returns the last item.

```lua
Collection({ 1, 2, 3 }):last()  -- 3
```

### `sortBy(key, [desc])`

Sorts objects by a key (ascending by default).

```lua
local users = Collection({ { name = "John", age = 30 }, { name = "Jane", age = 25 } })
users:sortBy("age"):pluck("name"):all()        -- { "Jane", "John" }
users:sortBy("age", true):pluck("name"):all()  -- { "John", "Jane" } (descending)
```

### `each(fn)`

Iterates over items for side effects (returns self).

```lua
Collection({ 1, 2, 3 }):each(function(item) print(item) end)
```

### `keys()`

Returns collection of keys (for map-like tables).

```lua
Collection({ a = 1, b = 2 }):keys():all()  -- { "a", "b" }
```

### `values()`

Returns collection of values (for map-like tables).

```lua
Collection({ a = 1, b = 2 }):values():all()  -- { 1, 2 }
```

### `dump()`

Prints the collection using `vim.inspect` (returns self for chaining).

```lua
Collection({ 1, 2, 3 }):dump()
```

## Chaining Example

```lua
local json = '[{"id":1,"name":"John","active":true},{"id":2,"name":"Jane","active":false},{"id":3,"name":"Bob","active":true}]'

local result = Collection.from_json(json)
  :where("active", true)
  :sortBy("name")
  :pluck("name")
  :all()

-- { "Bob", "John" }
```
