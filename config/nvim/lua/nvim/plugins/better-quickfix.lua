local M = {
	"kevinhwang91/nvim-bqf",
}

M.ft = { "qf", "qfreplace" }
M.dependencies = {
	require("nvim.plugins.fzf"),
	require("common.plugins.treesitter"),
}

return M
