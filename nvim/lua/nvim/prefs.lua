local M = {}

function M.catppuccin_flavor()
    return 'mocha'
end

function M.diagnostic_signs()
    return {
        Error = '󱇎',
        Hint = '󰌵',
        Warn = '󰀦',
        Info = '󰋼',
        Ok = '󰸞',
    }
end

function M.git_signs()
    return {
        added = '󰐕',
        modified = '󰦒',
        removed = '󰍴',
    }
end

return M
