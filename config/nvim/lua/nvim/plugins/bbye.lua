-- Better buffer interactions without destroying splits
--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"moll/vim-bbye",
}

M.cmd = {
	"Bdelete",
	"Bwipeout",
}

return M
