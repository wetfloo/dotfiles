-- This file needs to stay here
-- for plugins to work, apparently
return {
	-- fix for `fzf#install` not being available during load
	require("nvim.plugins.lib.fzf"),
}
