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

-- Bell
local function bell_color()
    local str_color
    if util.is_dark() then
        str_color = color.dark.ansi[3]
    else
        str_color = color.light.ansi[3]
    end

    return wezterm.color.parse(str_color)
end

config.audible_bell = "Disabled"
config.visual_bell = {
    fade_in_function = "Constant",
    fade_in_duration_ms = 1,
    fade_out_function = "Constant",
    fade_out_duration_ms = 250,
    target = "CursorColor",
}

config.colors = {
    tab_bar = tab_bar_colors(),
    visual_bell = bell_color(),
}

-- Keymap
local keymap = require("keymap")

config.disable_default_key_bindings = true
config.use_dead_keys = false

config.leader = keymap.leader
config.keys = keymap.keys
config.key_tables = keymap.key_tables

return config
