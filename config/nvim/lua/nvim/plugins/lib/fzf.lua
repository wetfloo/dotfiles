--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"junegunn/fzf",
}

M.build = function()
	vim.fn["fzf#install"]()
end

return M
