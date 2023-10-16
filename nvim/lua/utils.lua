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

readonlify_table(M)
return M
