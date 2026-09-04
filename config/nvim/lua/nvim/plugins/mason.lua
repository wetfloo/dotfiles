local M = {
	"mason-org/mason.nvim",
}

function M.cond()
	return not vim.g.started_by_firenvim
end

M.opts = {
	icons = {
		package_installed = "✓",
		package_pending = "➜",
		package_uninstalled = "✗",
	},
}

return M
