-- Define Gruvbox colors
local colors = {
  bg = "#282828",
  fg = "#ebdbb2",
  yellow = "#fabd2f",
  cyan = "#8ec07c",
  green = "#b8bb26",
  orange = "#fe8019",
  magenta = "#d3869b",
  blue = "#83a598",
  red = "#fb4934",
}

-- Function to get the current mode with color
local function mode()
  local modes = {
    n = { "NORMAL", colors.blue },
    i = { "INSERT", colors.green },
    v = { "VISUAL", colors.cyan },
    V = { "V-LINE", colors.cyan },
    [""] = { "V-BLOCK", colors.cyan },
    c = { "COMMAND", colors.magenta },
    R = { "REPLACE", colors.red },
    t = { "TERMINAL", colors.orange },
  }
  local current_mode = vim.api.nvim_get_mode().mode
  return "%#StatusLineAccent#" .. (modes[current_mode] or { "UNKNOWN", colors.red })[1] .. "%*"
end

-- Function to get the current file icon
local function fileicon()
  if vim.bo.filetype == "oil" then
    return ""
  end
  local icon, icon_highlight = require("nvim-web-devicons").get_icon_by_filetype(vim.bo.filetype, { default = true })
  return "%#" .. icon_highlight .. "#" .. icon .. "%*"
end

-- Function to get the current file name
local function filename()
  if vim.bo.filetype == "oil" then
    return vim.fn.getcwd()
  end
  local file = vim.fn.expand "%:t"
  if file == "" then
    return "[No Name]"
  end
  return file
end

-- Function to get the current file type
local function filetype()
  return vim.bo.filetype
end

-- Function to get the line and column number
local function linecol()
  return vim.fn.line "." .. ":" .. vim.fn.col "."
end

-- Function to get the percentage through the file
local function percentage()
  return math.floor(vim.fn.line "." / vim.fn.line "$" * 100) .. "%%"
end

-- Function to get the current Git branch
local function branch()
  if vim.bo.filetype == "oil" or vim.bo.filetype == "fugitive" or vim.bo.buftype == "terminal" then
    return ""
  end
  local Branch = require("plenary.job")
    :new({
      command = "git",
      args = { "branch", "--show-current" },
      cwd = vim.fn.expand "%:p:h",
      on_exit = function(j)
        return table.concat(j:result(), "\n")
      end,
    })
    :sync()

  if Branch == nil then
    return ""
  end

  if Branch[1] ~= "" then
    return " " .. Branch[1]
  end

  return ""
end

local function macro_recording()
  local noicemode = require("noice").api.status.mode.get()
  if noicemode then
    return string.match(noicemode, "^recording @.*") or ""
  end
  return ""
end

local function root_name()
  local cwd = vim.fn.getcwd()
  local last_dir = vim.fn.fnamemodify(cwd, ":t")

  return last_dir
end

local wakatime_today = ""

local function update_wakatime_today()
  local wakatime_cli = os.getenv "HOME" .. "/.wakatime/wakatime-cli-darwin-arm64"
  local handle = io.popen(wakatime_cli .. " --today")
  if handle == nil then
    return
  end
  local result = handle:read "*a"
  handle:close()
  wakatime_today = "  " .. result .. " "
end

-- Periodically update the wakatime_today variable
local timer = vim.loop.new_timer()
-- timer:start(0, 100000, vim.schedule_wrap(update_wakatime_today))

local function safe_call(func, default)
  local status, result = pcall(func)
  if status then
    return result
  else
    return default
  end
end

function _G.statusline()
  return table.concat {
    "%#StatusLine#",
    " ",
    safe_call(mode, ""),
    " ",
    safe_call(fileicon, ""),
    " ",
    safe_call(filename, "[No Name]"),
    " ",
    "[",
    safe_call(filetype, ""),
    "] ",
    " [",
    safe_call(branch, ""),
    "] ",
    "%=",
    " ",
    safe_call(macro_recording, ""),
    " ",
    safe_call(function() return wakatime_today end, ""),
    " ",
    safe_call(root_name, ""),
    " ",
    safe_call(linecol, "0:0"),
    " ",
    safe_call(percentage, "0%"),
    " ",
  }
end

-- Set the statusline
vim.o.statusline = "%!v:lua.statusline()"

-- Set highlight groups for statusline using Lua API
vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.bg, fg = colors.fg })
vim.api.nvim_set_hl(0, "StatusLineAccent", { bg = colors.bg, fg = colors.blue })
