# AGENTS.md - Neovim Configuration Development Guide

## Build/Test/Lint Commands
- **Lua formatting**: `stylua .` (uses stylua.toml config)
- **PHP formatting**: `pint` (Laravel Pint for PHP files)
- **Blade formatting**: `blade-formatter` (for Laravel Blade templates)
- **No test suite**: This is a personal Neovim config - no automated tests

## Code Style Guidelines

### Lua Files
- **Indentation**: 2 spaces (configured in stylua.toml)
- **Line width**: 120 characters max
- **Quotes**: Auto-prefer double quotes
- **Function calls**: No parentheses when possible (`require "module"` not `require("module")`)
- **Tables**: Use trailing commas, align values when readable

### File Organization
- **Plugin configs**: `/lua/plugins/` - one file per plugin or logical group
- **Keymaps**: `/lua/config/keymaps/` - modular keymap files that auto-load
- **Custom modules**: `/lua/custom/` - custom functionality and utilities
- **Main config**: `/lua/config/` - core configuration files

### Naming Conventions
- **Files**: kebab-case (`nvim-tree.lua`, `git-worktree.lua`)
- **Variables**: snake_case (`keymap_table`, `todo_path`)
- **Functions**: snake_case (`open_todo_floating`, `toggle_checkbox`)

### Plugin Configuration Patterns
- Use lazy loading with `lazy = false` only when necessary
- Prefer `opts = {}` over `config = function()` for simple setups
- Use `enabled = false` to disable plugins temporarily
- Group related plugins in single files when logical