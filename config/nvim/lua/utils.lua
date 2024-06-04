local function readonlify_table(table)
    setmetatable(table, {
        __index = table,
        __newindex = function() end,
    })
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
        local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
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

--- @param path string
--- @return string
function M.module_name(path)
    local result, _ = path:gsub("%w+%.", "")
    return result
end

function M.env(path)
    local result, _ = path:gsub("%.%w+", "")
    return result
end

--- @param path string
--- @param prev table
--- @return table
function M.plugin_config(path, prev)
    local module_name = M.module_name(path)
    local env = M.env(path)
    local config = require(env .. ".plugins.config." .. module_name)

    return vim.tbl_deep_extend("keep", prev, config)
end

function M.dir_content(dir)
    -- Note 1: if dir contains a trailing "/" because the CWD was acquired
    -- by means other than getcwd() (e.g. Lua string matching/substitution),
    -- then remove the "/" preceding the "*" in the above line to avoid "//" issues
    --
    -- Note 2: use {trimempty=true} to ensure that vim.split() drops
    -- empty space preceding a separator instead of treating it as en entity to keep.
    return vim.split(vim.fn.glob(dir .. "/*"), "\n", { trimempty = true })
end

function M.dir_contains(dir, name)
    local full_name = dir .. "/" .. name
    local contents = M.dir_content(dir)

    for _, item in pairs(contents) do
        if item == full_name then
            return true
        end
    end

    return false
end

readonlify_table(M)
return M
