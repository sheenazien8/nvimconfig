local M = {}

-- Function to pick a file from the routes directory using Telescope
function M.open_routes_file()
  -- Define your routes directory here (adjust the path based on your project structure)
  local routes_dir = vim.fn.getcwd() .. '/routes'

  -- Telescope command to list files in the routes directory
  require('telescope.builtin').find_files({
    prompt_title = 'Routes Files',
    cwd = routes_dir,  -- The directory to search in
    hidden = true,     -- Include hidden files (optional)
    no_ignore = true,  -- Ignore .gitignore files (optional)
  })
end

-- Register the command for opening routes files with Telescope
vim.api.nvim_create_user_command('OpenRoutesFile', M.open_routes_file, {})

return M

