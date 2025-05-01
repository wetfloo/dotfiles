return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		-- Since we have a status line already, don't duplicate current mode display
		vim.o.showmode = false

		local separator = "::"
		local function buffer_not_empty()
			return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
		end

		local function diagnostic_symbol(sym)
			return sym .. " "
		end

		local symbols = {
			Error = "󱇎",
			Warn = "󰀦",
			Info = "󰋼",
			Hint = "󰌵",
			Ok = "󰸞",
		}

		local _, noirbuddy = pcall(require, "noirbuddy.plugins.lualine")
		local _, lackluster = pcall(require, "lackluster")
		local theme
		if noirbuddy ~= nil then
			theme = noirbuddy.theme
		elseif lackluster ~= nil then
			theme = "lackluster"
		else
			theme = "auto"
		end

		local diagnostics_color = {}

		local function add_custom_hl(key, og_hl_name)
			local _, color_special = pcall(require, "lackluster.color-special")
			if color_special == nil then
				return
			end

			local new_hl_name = og_hl_name .. "Custom"
			local hlgroup = vim.api.nvim_get_hl(0, {
				name = og_hl_name,
				create = false,
			})
			if hlgroup ~= nil then
				local new_hlgroup = vim.tbl_deep_extend("error", hlgroup, {
					bg = color_special.statusline,
				})
				vim.api.nvim_set_hl(0, new_hl_name, new_hlgroup)
				diagnostics_color[key] = new_hl_name
			end
		end

		if lackluster ~= nil then
			add_custom_hl("hint", "DiagnosticSignHint")
			add_custom_hl("info", "DiagnosticSignInfo")
			add_custom_hl("warn", "DiagnosticSignWarn")
			add_custom_hl("error", "DiagnosticSignError")
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = theme,
				component_separators = separator,
				section_separators = " ",
			},
			sections = {
				-- Left side.
				lualine_a = {
					"mode",
				},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						cond = buffer_not_empty,
					},
					{
						"diagnostics",
						diagnostics_color = diagnostics_color,
						symbols = {
							error = diagnostic_symbol(symbols.Error),
							warn = diagnostic_symbol(symbols.Warn),
							info = diagnostic_symbol(symbols.Info),
							ok = diagnostic_symbol(symbols.Ok),
							hint = diagnostic_symbol(symbols.Hint),
						},
					},
				},

				-- Right side.
				lualine_x = {
					"diff",
					"filetype",
					{
						"o:encoding",
						fmt = string.lower,
					},
					{
						"fileformat",
						icons_enabled = false,
					},
					"location",
				},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
