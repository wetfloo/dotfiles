--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"https://codeberg.org/andyg/leap.nvim",
}

function M.init(_)
	vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
	vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
end

return M
