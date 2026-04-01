return {

	-- Highlight, edit, and navigate code

	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	branch = "main",
	lazy = false,
	config = function()
		require("nvim-treesitter").install({
			"asm",
			"awk",
			"bash",
			"c",
			"cmake",
			"cpp",
			"dockerfile",
			"fish",
			"gitcommit",
			"gitignore",
			"go",
			"gomod",
			"gosum",
			"gowork",
			"groovy",
			"java",
			"json",
			"kotlin",
			"lua",
			"make",
			"markdown",
			"objc",
			"powershell",
			"proto",
			"python",
			"rust",
			"tmux",
			"toml",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		})
	end,
}

-- TODO: incremental selection,
-- conditional highlights, etc.
--
-- See diffs for `7657f97093a33e1f5e320fec3ac7482e5964e6a9`
