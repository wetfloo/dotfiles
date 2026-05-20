local M = {
	"kylechui/nvim-surround",
}

M.version = "*"
M.keys = {
	{ "ys", mode = "n" },
	{ "ds", mode = "n" },
	{ "cs", mode = "n" },
	{ "<C-g>s", mode = "i" },
	{ "S", mode = "x" },
}

return M
