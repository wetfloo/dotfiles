local M = {
	"https://codeberg.org/andyg/leap.nvim",
}

function M.config(_plug, opts)
	local leap = require("leap")
	leap.setup(opts)

	vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
	vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
end

return M
