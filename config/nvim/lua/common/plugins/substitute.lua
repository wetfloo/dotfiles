--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"gbprod/substitute.nvim",
}

M.keys = {
	{ "cx", mode = "n" },
	{ "<leader>X", mode = "x" },
}

function M.opts(_, _)
	local exchange = require("substitute.exchange")
	vim.keymap.set("n", "cx", exchange.operator, { desc = "Substitute text object" })
	vim.keymap.set("n", "cxx", exchange.line, { desc = "Substitute current line " })
	vim.keymap.set("n", "cxc", exchange.cancel, { desc = "Cancel substitute" })
	vim.keymap.set("x", "<leader>X", exchange.visual, { desc = "Substitute selection" })

	return {}
end

return M
