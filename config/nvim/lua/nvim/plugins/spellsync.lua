--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"micarmst/vim-spellsync",
}

M.cmd = {
	"SpellSync",
}

M.event = {
	"VeryLazy",
}

return M
