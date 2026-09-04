--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"glacambre/firenvim",
}

function M.build()
	vim.fn["firenvim#install"](0)
end

function M.cond()
	return vim.g.started_by_firenvim
end

function M.init()
	vim.g.firenvim_config = {
		localSettings = {
			[".*"] = {
				takeover = "never",
				priority = 0,
			},

			["http(s?)://code.yandex-team.ru/.*"] = {
				takeover = "always",
				priority = 1,
			},

			["http(s?)://go.dev/play/.*"] = {
				takeover = "always",
				selector = "textarea#code",
				priority = 1,
			},
		},
	}
end

return M
