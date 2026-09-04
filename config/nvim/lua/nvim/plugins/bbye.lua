-- Better buffer interactions without destroying splits
--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"moll/vim-bbye",
}

function M.cond()
	return not vim.g.started_by_firenvim
end

M.cmd = {
	"Bdelete",
	"Bwipeout",
}

return M
