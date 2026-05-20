--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"junegunn/fzf",
}

M.build = vim.fn["fzf#install"]

M.lazy = true

return M
