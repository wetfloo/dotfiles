--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"j-hui/fidget.nvim",
}

M.tag = "v1.5.0"

M.event = "LspAttach"

M.opts = {
	notification = {
		window = {
			winblend = 0,
		},
	},
	progress = {
		suppress_on_insert = true,
		display = {
			render_limit = 3,
		},
	},
}

return M
