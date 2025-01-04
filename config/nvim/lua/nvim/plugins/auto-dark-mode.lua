local function setup_devicons(color_icons, default_icon)
    local _, devicons = pcall(require, "nvim-web-devicons")
    if devicons == nil then
        return
    end

    devicons.setup({
        color_icons = color_icons,
        ["default-icon"] = default_icon,
    })
end

return {
    enabled = false,
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        update_interval = 10000,
        set_dark_mode = function()
            vim.api.nvim_set_option_value("background", "dark", {})
            local lackluster = require("lackluster")
            lackluster.setup({
                tweak_background = {
                    normal = color.black,
                },
            })
            vim.opt.colorscheme("lackluster")
        end,
        set_light_mode = function()
            vim.api.nvim_set_option_value("background", "light", {})
            local lackluster = require("lackluster")
            lackluster.setup({
                tweak_background = {
                    normal = color.white,
                },
            })
            vim.opt.colorscheme("lackluster")
        end,
    },
}
