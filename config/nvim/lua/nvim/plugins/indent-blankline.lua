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

return M
