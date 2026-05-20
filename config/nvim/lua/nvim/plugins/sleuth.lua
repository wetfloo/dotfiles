--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"tpope/vim-sleuth",
}

M.event = {
	"BufEnter",
}

return M
