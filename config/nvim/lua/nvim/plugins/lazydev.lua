--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"folke/lazydev.nvim",
}

M.ft = "lua"

function M.cond()
	return not vim.g.started_by_firenvim
end

function M:config()
	-- Monkeypatch in a PR to remove a call to the deprecated `client.notify`
	-- function.
	--
	-- See: https://github.com/folke/lazydev.nvim/pull/106
	local config = require("lazydev.config")
	config.have_0_11 = vim.fn.has("nvim-0.11") == 1

	local lsp = require("lazydev.lsp")
	--- @diagnostic disable-next-line: duplicate-set-field
	lsp.update = function(client)
		lsp.assert(client)
		if config.have_0_11 then
			client:notify("workspace/didChangeConfiguration", {
				settings = { Lua = {} },
			})
		else
			--- @diagnostic disable-next-line: param-type-mismatch
			client.notify("workspace/didChangeConfiguration", {
				settings = { Lua = {} },
			})
		end
	end

	require("lazydev").setup({
		library = {
			-- See the configuration section for more details
			-- Load luvit types when the `vim.uv` word is found
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	})
end

return M
