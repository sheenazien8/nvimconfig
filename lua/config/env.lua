local M = {}

M.is_server = false
M.is_minimal = false

local function detect_server()
  local hostname = vim.fn.hostname()
  local env_server = os.getenv "NVIM_SERVER"
  local env_minimal = os.getenv "NVIM_MINIMAL"

  if env_server == "1" or env_minimal == "1" then
    return true
  end

  local server_indicators = {
    "server",
    "prod",
    "staging",
    "remote",
    "ssh",
    "vps",
    "aws",
    "digitalocean",
    "linode",
  }

  for _, indicator in ipairs(server_indicators) do
    if hostname:lower():find(indicator) then
      return true
    end
  end

  if os.getenv "SSH_CONNECTION" or os.getenv "SSH_CLIENT" then
    return true
  end

  return false
end

M.is_server = detect_server()
M.is_minimal = M.is_server

M.disabled_plugins_on_server = {
  "nvim-lspconfig",
  "conform",
  "nvim-treesitter",
  "copilot",
  "codecompanion",
  "noice",
  "trouble",
  "neotest",
  "nvim-dap",
  "flutter-tools",
  "minuet-ai",
  "ufo",
  "nvim-cmp",
  "nvim-snippets",
}

function M.should_load_plugin(plugin_name)
  if not M.is_minimal then
    return true
  end

  for _, disabled in ipairs(M.disabled_plugins_on_server) do
    if plugin_name:lower():find(disabled:lower()) then
      return false
    end
  end

  return true
end

function M.setup()
  if M.is_server then
    vim.notify("Running in server/minimal mode", vim.log.levels.INFO)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end
end

return M