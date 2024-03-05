local local_settings = {
    ['.*google\\.\\w+/search.*'] = {
        takeover = 'never',
        priority = 1,
    },
    ['.*figma.com.*'] = {
        takeover = 'never',
        priority = 1,
    },
}

return {
    'glacambre/firenvim',

    enabled = false,
    lazy = not vim.g.started_by_firenvim,
    build = function()
        vim.fn['firenvim#install'](0)
    end,
    config = function()
        vim.g.firenvim_config = {
            globalSettings = {
                selector = 'textarea',
            },
            localSettings = vim.tbl_deep_extend(
                "keep",
                local_settings,
                require('common.plugins.os_local.firenvim') or {}
            ),
        }
    end,
}
