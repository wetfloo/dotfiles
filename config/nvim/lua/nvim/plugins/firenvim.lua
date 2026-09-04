--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"glacambre/firenvim",
}

function M.build()
	vim.fn["firenvim#install"](0)
end

function M.cond()
	return vim.g.started_by_firenvim == true
end

function M.init()
	vim.g.firenvim_config = {
		localSettings = {
			[".*"] = {
				takeover = "never",
				priority = 0,
			},

			["https://code.yandex-team.ru/.*"] = {
				takeover = "always",
				priority = 1,
			},

			["https://go.dev/.*"] = {
				takeover = "always",
				priority = 1,
			},
		},
	}
end

return M
