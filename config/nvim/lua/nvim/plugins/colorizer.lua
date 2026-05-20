local M = {
	"catgoose/nvim-colorizer.lua",
	priority = 1000,
	lazy = false,
	opts = {
		filetypes = {
			["css"] = {
				names = true,
			},
		},
		user_default_options = {
			names = false,
		},
	},
}

return M
