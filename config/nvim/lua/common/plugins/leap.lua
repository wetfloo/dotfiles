--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"https://codeberg.org/andyg/leap.nvim",
}

function M:init()
	vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
	vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
end

return M
