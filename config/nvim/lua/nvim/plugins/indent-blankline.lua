return {
	"lukas-reineke/indent-blankline.nvim",
	enabled = false,
	event = {
		"VeryLazy",
	},
	main = "ibl",
	opts = {
		indent = {
			highlight = { "LineNr" },
			-- char = '',
		},
		scope = { enabled = false },
		exclude = {
			filetypes = {
				"help",
				"*oil*",
				"lazy",
				"asm",
				"",
			},
		},
	},
}
