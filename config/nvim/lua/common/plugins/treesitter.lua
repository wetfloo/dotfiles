--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	-- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
}

M.build = ":TSUpdate"

M.branch = "main"

M.lazy = false

function M:build()
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

function M:init()
	-- Toggle mappings
	vim.keymap.set("n", "<leader>st", function()
		if vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil then
			vim.treesitter.stop()
			vim.print("Turned off treesitter highlighting...")
		else
			vim.treesitter.start()
			vim.print("Turned on treesitter highlighting...")
		end
	end, { noremap = true, silent = true, desc = "Toggle treesitter highlighting" })
end

return M
