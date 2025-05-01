local M = {}

local wezterm = require("wezterm")

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
M.is_dark = function()
	if wezterm.gui then
		return wezterm.gui.get_appearance():find("Dark")
	end

	return true
end

return M
