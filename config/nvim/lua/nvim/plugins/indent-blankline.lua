--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"lukas-reineke/indent-blankline.nvim",
}

M.event = {
	"BufEnter",
}

M.main = "ibl"

---@module "ibl"
---@type ibl.config
M.opts = {
	indent = {
		char = "┋",
		tab_char = "┃",
	},
	scope = {
		show_start = false,
		show_end = false,
	},
}

function M:config(opts)
	require("ibl").setup(opts)

	local hooks = require("ibl.hooks")
	hooks.register(hooks.type.SKIP_LINE, function(_, _, _, line)
		return line == ""
	end)
end

return M
