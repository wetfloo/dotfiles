--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"ThePrimeagen/harpoon",
}

M.branch = "harpoon2"

M.dependencies = {
	require("common.plugins.lib.plenary"),
}

M.lazy = true

M.init = function(_)
	local function toggle_telescope(harpoon_files)
		local _, tsc = pcall(require, "telescope.config")
		if tsc == nil then
			return
		end
		local telescope_conf = tsc.values

		local file_paths = {}
		for _, item in ipairs(harpoon_files.items) do
			table.insert(file_paths, item.value)
		end

		require("telescope.pickers")
			.new({}, {
				prompt_title = "Harpoon",
				finder = require("telescope.finders").new_table({
					results = file_paths,
				}),
				previewer = telescope_conf.file_previewer({}),
				sorter = telescope_conf.generic_sorter({}),
			})
			:find()
	end
	vim.keymap.set("n", "<leader>hh", function()
		require("harpoon"):list():add()
	end, { desc = "Add a bookmark" })

	vim.keymap.set("n", "<leader>hd", function()
		require("harpoon"):list():remove()
	end, { desc = "Remove current file's bookmark" })

	vim.keymap.set("n", "<leader>hD", function()
		require("harpoon"):list():clear()
	end, { desc = "Delete ALL bookmarks" })

	vim.keymap.set("n", "<leader>hm", function()
		-- TODO: use autocmd for this
		require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
	end, { desc = "Show bookmarks menu" })

	vim.keymap.set("n", "<leader>hn", function()
		require("harpoon"):list():next()
	end, { desc = "Next bookmark" })

	vim.keymap.set("n", "<leader>hp", function()
		require("harpoon"):list():prev()
	end, { desc = "Previous bookmark" })

	vim.keymap.set("n", "<leader>fm", function()
		toggle_telescope(require("harpoon"):list())
	end, { desc = "Telescope: Harpoon" })

	local keys = { "q", "w", "e", "r", "t", "y", "u", "i", "o" }
	for i, v in ipairs(keys) do
		vim.keymap.set("n", "<leader>h" .. v, function()
			require("harpoon"):list():replace_at(i)
		end, { desc = "Replace bookmark at " .. i .. " with current file" })

		vim.keymap.set("n", "<A-" .. v .. ">", function()
			require("harpoon"):list():select(i)
		end, { desc = "Go to bookmark" .. i })
	end
end

return M
