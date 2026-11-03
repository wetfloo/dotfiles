--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"folke/which-key.nvim",
}

M.event = "VeryLazy"

M.opts = {
	delay = function(ctx)
		return ctx.plugin and 0 or 1000
	end,
}

return M
