--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"jinh0/eyeliner.nvim",
}

local function modes(key)
	return { key, mode = { "n", "x", "o" } }
end

M.keys = {
	modes("f"),
	modes("F"),
	modes("t"),
	modes("T"),
}

function M.init(_)
	vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = "#fa579c", bold = true, underline = false })
	vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = "#add149", bold = true, underline = false })
end

M.opts = {
	highlight_on_key = true,
	dim = true,
}

return M
