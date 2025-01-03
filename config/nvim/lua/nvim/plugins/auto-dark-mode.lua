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
    enabled = true,
    "f-person/auto-dark-mode.nvim",
    opts = {
        update_interval = 10000,
        set_dark_mode = function()
            vim.api.nvim_set_option_value("background", "dark", {})

            local lackluster = require("lackluster")
            local color = lackluster.color -- blue, green, red, orange, black, lack, luster, gray1-9
            setup_devicons(false, {
                color = lackluster.color.gray4,
                name = "Default",
            })

            vim.cmd.colorscheme("lackluster")
        end,
        set_light_mode = function()
            vim.api.nvim_set_option_value("background", "light", {})

            local palette = require("github-theme.palette").load("github_light")
            setup_devicons(true, {
                color = palette.fg1,
                name = "Default",
            })
            vim.cmd.colorscheme("github_light")
        end,
    },
}
