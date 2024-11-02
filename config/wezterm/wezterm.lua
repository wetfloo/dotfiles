local wezterm = require("wezterm")
local util = require("util")

local config = wezterm.config_builder()

-- Color
local color = require("prefs.color")

local function scheme_for_appearance()
    if util.is_dark() then
        return color.names.dark
    else
        return color.names.light
    end
end

config.color_schemes = color.schemes
config.color_scheme = scheme_for_appearance()

-- Font
config.font = wezterm.font({
    family = "Iosevka Term",
    weight = "Regular",
})
config.line_height = 1.2
config.font_size = 14

-- Window frame
local function tab_bar_colors()
    local result = {}
    local function parse(str_color)
        return wezterm.color.parse(str_color)
    end

    if util.is_dark() then
        result = {
            background = parse(color.dark.background):lighten(0.05),
            active_tab = {
                bg_color = parse(color.dark.background),
                fg_color = parse(color.dark.ansi[8]),
            },
        }
    else
        result = {
            background = parse(color.light.background):darken(0.05),
            active_tab = {
                bg_color = parse(color.light.background),
                fg_color = parse(color.light.ansi[1]),
            },
        }
    end

    return result
end

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.colors = {
    tab_bar = tab_bar_colors(),
}

return config
