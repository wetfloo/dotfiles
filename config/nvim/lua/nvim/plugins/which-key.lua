--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"folke/which-key.nvim",
}

M.event = "VeryLazy"

M.opts = {
	delay = 2000,
}

return M
