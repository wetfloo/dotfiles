--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"mbbill/undotree",
}

M.ft = { "undotree" }

M.cmd = {
	"UndotreeToggle",
	"UndotreeFocus",
	"UndotreeHide",
	"UndotreePersistUndo",
	"UndotreeShow",
	"UndotreeRemotePlugins",
}

function M:init()
	vim.keymap.set("n", "<leader>tu", function()
		vim.cmd("UndotreeToggle")
	end, { desc = "Undo tree" })
end

return M
