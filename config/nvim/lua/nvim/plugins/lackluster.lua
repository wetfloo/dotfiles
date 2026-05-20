--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"slugbyte/lackluster.nvim",
}

M.lazy = false

M.priority = 1000

M.dependencies = {
	require("common.plugins.lib.plenary"),
	require("nvim.plugins.lib.nvim-web-devicons"),
}

function M.config(_, _)
	local lackluster = require("lackluster")
	local color = lackluster.color -- blue, green, red, orange, black, lack, luster, gray1-9
	lackluster.setup({
		tweak_highlight = {
			["TelescopeMatching"] = {
				fg = color.black,
				bg = color.gray7,
			},
			["OilDir"] = {
				fg = color.gray8,
			},
			["OilDirIcon"] = {
				fg = color.gray8,
			},
			["DiagnosticUnderlineInfo"] = {
				overwrite = true,
				underline = false,
			},
			["DiagnosticUnderlineHint"] = {
				overwrite = true,
				underline = false,
			},
			["DiagnosticUnderlineWarn"] = {
				overwrite = true,
				underline = false,
			},
			["DiagnosticUnderlineError"] = {
				overwrite = true,
				underline = false,
			},
			["DiagnosticFloatingInfo"] = {
				overwrite = true,
				fg = color.gray7,
			},
			["DiagnosticFloatingHint"] = {
				overwrite = true,
				fg = color.gray7,
			},
			["DiagnosticFloatingWarn"] = {
				overwrite = true,
				fg = color.gray7,
			},
			["DiagnosticFloatingError"] = {
				overwrite = true,
				fg = color.gray7,
			},
		},
		tweak_background = {
			normal = color.black,
			-- normal = "none",
			-- telescope = "none",
			-- popup = color.black,
		},
	})

	local devicons = require("nvim-web-devicons")
	devicons.setup({
		color_icons = false,
		["default-icon"] = {
			color = lackluster.color.gray4,
			name = "Default",
		},
	})

	vim.cmd.colorscheme("lackluster")
	-- vim.cmd.colorscheme("lackluster-hack")
	-- vim.cmd.colorscheme("lackluster-mint")
end

return M
