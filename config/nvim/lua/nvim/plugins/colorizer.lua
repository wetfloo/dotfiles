--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"catgoose/nvim-colorizer.lua",
}

M.priority = 1000

M.lazy = false

M.opts = {
	filetypes = {
		["css"] = {
			names = true,
		},
	},
	user_default_options = {
		names = false,
	},
}

return M
