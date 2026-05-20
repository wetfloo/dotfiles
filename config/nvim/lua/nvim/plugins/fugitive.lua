local utils = require("utils")

--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"tpope/vim-fugitive",
}

M.cmd = {
	"G",
	"Git",
}

M.ft = {
	"fugitive",
	"fugitiveblame",
}

function M:init()
	vim.keymap.set("n", "<leader>kb", function()
		utils.close_win_with_ft_or("fugitiveblame", false, function()
			vim.cmd("Git blame")
		end)
	end, { desc = "Toggle git blame side window (git)" })
	vim.keymap.set("n", "<leader>kg", function()
		utils.close_win_with_ft_or("fugitive", false, function()
			vim.cmd("Git")
		end)
	end, { desc = "Toggle git window (git)" })
end

return M
