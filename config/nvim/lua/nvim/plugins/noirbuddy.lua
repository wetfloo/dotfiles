return {
	"jesseleite/nvim-noirbuddy",
	enabled = false,
	dependencies = {
		{ "tjdevries/colorbuddy.nvim", branch = "master" },
	},
	lazy = false,
	priority = 1000,
	config = function()
		local colorbuddy = require("colorbuddy")
		local noirbuddy = require("noirbuddy")
		noirbuddy.setup({
			colors = {
				primary = "#f5a9b8",
				secondary = "#5bcefa",
				background = "#000000",

				diagnostic_error = "#ff474a",
				diagnostic_warning = "#ffe561",
				diagnostic_info = "#61fffc",
				diagnostic_hint = "#61fffc",

				diff_add = "#1aff85",
				diff_change = "#adf5ff",
				diff_delete = "#ff6183",
			},
		})

		local Group = colorbuddy.Group
		local colors = colorbuddy.colors

		Group.new("@string", colors.secondary)
		Group.new("@variable", colors.primary)
		Group.new("@variable.member", colors.noir_2)
		Group.new("ErrorMsg", colors.secondary)
		Group.new("WarningMsg", colors.secondary)
	end,
}
