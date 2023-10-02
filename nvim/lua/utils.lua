local M = {}

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

return M
