local M = {
	-- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
}

M.build = ":TSUpdate"
M.branch = "main"
M.lazy = false
function M.config()
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
end

-- TODO: incremental selection,
-- conditional highlights, etc.
--
-- See diffs for `7657f97093a33e1f5e320fec3ac7482e5964e6a9`
return M
