local local_settings = {
    ["https://code\\.o3.*"] = {
        takeover = "always",
        selector = 'div[class="view-lines"]',
        content = "html",
    },
    ["https://play\\.kotlinlang\\.org.*"] = {
        takeover = "always",
        command = {
            "set ft=kotlin",
            "LspStop",
        },
    },
}

return {
    "glacambre/firenvim",
    enabled = true,

    lazy = not vim.g.started_by_firenvim,
    build = function()
        vim.fn["firenvim#install"](0)
    end,
    config = function()
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
            callback = function(e)
                if vim.g.timer_started == true then
                    return
                end
                vim.g.timer_started = true
                vim.fn.timer_start(1000, function()
                    vim.g.timer_started = false
                    vim.cmd("silent write")
                end)
            end,
        })

        vim.g.firenvim_config = {
            globalSettings = {
                takeover = "never",
                priority = 0,
                alt = "all",
                cmdlineTimeout = 3000,
            },

            localSettings = vim.tbl_deep_extend(
                "keep",
                local_settings,
                require("common.plugins.os_local.firenvim") or {}
            ),
        }
    end,
}
