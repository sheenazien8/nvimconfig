# Neovim Configuration

This repository contains my Neovim configuration files. My setup uses Lua for configuration, with Lazy.nvim for managing plugins and Gruvbox as the theme.

## Table of Contents

- [Installation](#installation)
- [Plugins](#plugins)
- [Configuration Structure](#configuration-structure)
- [Key Mappings](#key-mappings)
- [Custom Functions](#custom-functions)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)

## Installation

### Prerequisites

- Neovim (v0.11 or later)
- Git

### Steps

1. Clone this repository:
   
   ```sh
   git clone https://github.com/sheenazien8/nvimconfig ~/.config/nvim
   ```

2. Install plugins:

   Open Neovim and run:

   ```vim
   :Lazy install
   ```

3. Restart Neovim.

## Plugins

This configuration uses Lazy.nvim to manage plugins. Here are some of the key plugins included:

- [Lazy.nvim](https://github.com/folke/lazy.nvim): A plugin manager for Neovim.
- [Gruvbox](https://github.com/ellisonleao/gruvbox.nvim): A retro groove color scheme for Vim.
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter): Treesitter configurations and abstraction layer for Neovim.
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim): A highly extendable fuzzy finder over lists.

## Configuration Structure

The configuration files are organized as follows:

```
~/.config/nvim/
├── init.lua         # Main configuration file
├── lua/
│   ├── config/      # Plugin configurations
│   ├── custom/      # Custom Lua functions and scripts
│   ├── plugins/     # Neovim settings and options
|   └── init.lua     # Bootsrap all the configuration
```

### Example `init.lua`

```lua
require "init"
```

## Key Mappings

Key mappings are defined in the `lua/config/keymap.lua` file. Here are some of the key mappings included:

- `<leader>sf`: Find files using Telescope
- `<leader>sg`: Live grep using Telescope
- `<leader>sb`: List buffers using Telescope

## Custom Functions

Custom functions are defined in the `lua/custom/` directory. These functions extend the functionality of Neovim and are used throughout the configuration.

## Screenshots

Here are some screenshots of my Neovim setup:

![Neovim with Gruvbox](https://github.com/sheenazien8/nvimconfig/assets/37477023/9e858360-6e64-4cb2-ae28-9f57f62464c8)

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue if you have any suggestions or improvements.

## License

This configuration is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

---

Feel free to adjust the Markdown formatting as needed for your repository.
<<<<<<< HEAD
>>>>>>> 7d7111c12165f5a437d175ad7bf335a98aa9539f
=======
>>>>>>> 7d7111c12165f5a437d175ad7bf335a98aa9539f
