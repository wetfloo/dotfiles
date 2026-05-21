--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"kevinhwang91/nvim-bqf",
}

M.ft = "qf"

M.dependencies = {
	require("nvim.plugins.lib.fzf"),
	require("common.plugins.treesitter"),
}

return M
