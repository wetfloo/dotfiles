return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		local harpoon = require("harpoon")

		local telescope_conf = require("telescope.config").values

		local function toggle_telescope(harpoon_files)
			local ok, _ = pcall(require, "telescope")
			if not ok then
				return
			end

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

		local function normalize_path(buf_name, root)
			local path = require("plenary.path")
			return path:new(buf_name):make_relative(root)
		end

		local current_buf

		local function get_buf_path(buf)
			if current_buf == nil then
				return nil
			end

			local root = harpoon.config.default.get_root_dir()
			local current_buf_name = vim.api.nvim_buf_get_name(current_buf)
			return normalize_path(current_buf_name, root)
		end

		harpoon:setup({
			--     default = {
			-- TODO: wtf, it seems that display fn affects how buffers are selected?
			-- Absolute nonsense.
			--         display = function(list_item)
			--             local list_value = list_item.value
			--             local result = list_value
			--
			--             if not vim.api.nvim_buf_is_loaded(current_buf) then
			--                 result = "󰚌  " .. result
			--             end
			--
			--             local current_buf_path = get_buf_path(current_buf)
			--             if current_buf_path ~= nil and list_value == current_buf_path then
			--                 result = "> " .. result
			--             end
			--
			--             return result
			--         end,
			--     },
		})

		vim.keymap.set("n", "<leader>hh", function()
			harpoon:list():add()
		end, { desc = "Add a bookmark" })

		vim.keymap.set("n", "<leader>hd", function()
			harpoon:list():remove()
		end, { desc = "Remove current file's bookmark" })

		vim.keymap.set("n", "<leader>hD", function()
			harpoon:list():clear()
		end, { desc = "Delete ALL bookmarks" })

		vim.keymap.set("n", "<leader>hm", function()
			-- TODO: use autocmd for this
			current_buf = vim.api.nvim_get_current_buf()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Show bookmarks menu" })

		vim.keymap.set("n", "<leader>hn", function()
			harpoon:list():next()
		end, { desc = "Next bookmark" })

		vim.keymap.set("n", "<leader>hp", function()
			harpoon:list():prev()
		end, { desc = "Previous bookmark" })

		vim.keymap.set("n", "<leader>fm", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Telescope: Harpoon" })

		local keys = { "q", "w", "e", "r", "t", "y", "u", "i", "o" }
		for i, v in ipairs(keys) do
			vim.keymap.set("n", "<leader>h" .. v, function()
				harpoon:list():replace_at(i)
			end, { desc = "Replace bookmark at " .. i .. " with current file" })

			vim.keymap.set("n", "<A-" .. v .. ">", function()
				harpoon:list():select(i)
			end, { desc = "Go to bookmark" .. i })
		end
	end,
}
