local M = {
	"kevinhwang91/nvim-bqf",
	ft = "qf",
	dependencies = {
		{
			"junegunn/fzf",
			build = vim.fn["fzf#install"],
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
		},
	},
}

return M
