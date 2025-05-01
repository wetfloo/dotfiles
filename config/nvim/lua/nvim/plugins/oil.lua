return {
	"stevearc/oil.nvim",
	-- uncomment this line when needing to download dictionaries,
	-- then comment it back again
	-- cmd = 'Oil',
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	version = "2.13",
	config = function()
		local oil = require("oil")
		oil.setup({
			columns = {
				"mtime",
				"icon",
			},
			view_options = {
				show_hidden = true,
			},
			use_default_keymaps = false,
			keymaps = {
				["<leader>t?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<leader>tv"] = "actions.select_vsplit",
				["<leader>th"] = "actions.select_split",
				["<leader>tn"] = "actions.select_tab",
				["<leader>tp"] = "actions.preview",
				["<leader>tt"] = "actions.close",
				["<leader>tr"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["<leader>ts"] = "actions.change_sort",
				["<leader>tx"] = "actions.open_external",
				["<leader>t."] = "actions.toggle_hidden",
				["<leader>tq"] = "actions.send_to_qflist",
				["<leader>tQ"] = "actions.add_to_qflist",
			},
		})

		vim.keymap.set("n", "<leader>tT", function()
			oil.toggle_float(nil)
		end, { desc = "File explorer (floating)" })
		vim.keymap.set("n", "<leader>tt", function()
			vim.cmd("Oil")
		end, { desc = "File explorer (fullscreen)", silent = true })
	end,
}
