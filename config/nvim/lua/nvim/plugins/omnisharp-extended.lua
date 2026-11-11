--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"Hoffs/omnisharp-extended-lsp.nvim",
}

-- Needed to handle the `omnisharp` LSP's nonsense `$metadata` paths
-- correctly.
M.ft = "cs"

function M.cond()
	return not vim.g.started_by_firenvim
end

return M
