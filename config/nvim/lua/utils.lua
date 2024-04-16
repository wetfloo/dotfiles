local function readonlify_table(table)
    setmetatable(
        table,
        {
            __index = table,
            __newindex = function() end,
        }
    )
end

local M = {}

M.readonlify_table = readonlify_table

--- Example
---
--- M.function_name = function(params)
---     ...
--- end
---
--- Then, in the target module:
--- local module = require('utils')
--- module.function_name(params)

function M.leader_prefix(keys)
    return vim.g.mapleader .. keys
end

--- Finds all open windows that match the given {ft}
--- @param ft string
--- @return table
function M.find_open_wins_with_ft(ft)
    local wins = vim.api.nvim_list_wins()
    -- Their respective buffers
    local bufs = {}
    for _, win in ipairs(wins) do
        bufs[win] = vim.api.nvim_win_get_buf(win)
    end

    local result = {}
    for win, buf in pairs(bufs) do
        local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
        if filetype == ft then
            table.insert(result, win)
        end
    end

    return result
end

--- Close all windows with a given {ft}, or run provided {fn}, if available
--- @param ft string
--- @param force boolean
--- @param fn function|nil
function M.close_win_with_ft_or(ft, force, fn)
    local wins = M.find_open_wins_with_ft(ft)

    if #wins == 0 then
        if fn ~= nil then
            fn()
        end
    else
        for _, win in ipairs(wins) do
            vim.api.nvim_win_close(win, force)
        end
    end
end

readonlify_table(M)
return M
