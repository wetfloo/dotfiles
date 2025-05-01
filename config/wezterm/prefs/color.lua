local M = {
	names = {
		dark = "Firefly Traditional",
		light = "Terminal Basic",
	},
	schemes = {},
}

setmetatable(M, {
	__index = function(table, key)
		if rawget(table, key) then
			return rawget(table, key)
		end

		local name = table.names[key]
		if name then
			return table.schemes[name]
		end
	end,
})

local wezterm = require("wezterm")

local builtin_color_schemes = wezterm.color.get_builtin_schemes()

local dark = builtin_color_schemes[M.names.dark]
dark.cursor_border = "#aaaaaa"
dark.cursor_bg = "#aaaaaa"
dark.cursor_fg = "#000000"
M.schemes[M.names.dark] = dark

local light = builtin_color_schemes[M.names.light]
light.cursor_border = "#222222"
light.cursor_bg = "#222222"
light.cursor_fg = "#eeeeee"
M.schemes[M.names.light] = light

return M
