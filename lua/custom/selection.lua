local M = {}

-- Get visual selection (line-wise)
function M.get_visual_selection()
    local mode = vim.fn.mode()

    -- Not in visual mode → return nil
    if mode ~= "v" and mode ~= "V" and mode ~= "" then
        return nil
    end

    local s = vim.fn.getpos("'<")
    local e = vim.fn.getpos("'>")

    local start_line = s[2]
    local end_line = e[2]

    return vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
end

-- Get current line under cursor
function M.get_current_line()
    return vim.api.nvim_get_current_line()
end

-- Get current line number
function M.get_current_line_number()
    return vim.api.nvim_win_get_cursor(0)[1]
end

return M

