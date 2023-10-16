local M = {}

M.catppuccin_flavor = 'mocha'

M.diagnostic_signs = {
    Error = '󱇎',
    Hint = '󰌵',
    Warn = '󰀦',
    Info = '󰋼',
    Ok = '󰸞',
}

M.git_signs = {
    added = '󰐕',
    modified = '󰦒',
    removed = '󰍴',
}

require('utils').readonlify_table(M)
return M
