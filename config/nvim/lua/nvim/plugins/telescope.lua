--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"nvim-telescope/telescope.nvim",
}

M.version = "^0.2"

M.dependencies = {
	require("common.plugins.lib.plenary"),
	require("nvim.plugins.lib.telescope-fzf-native"),
}

M.lazy = true

M.cmd = { "Telescope" }

M.opts = {
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
	},
	pickers = {
		oldfiles = {
			cwd_only = true,
		},
	},
}

function M:init()
	local function map_under_cursor(keys, fn, desc)
		local uppered = (keys:gsub("(.)$", string.upper))
		vim.keymap.set("n", "<leader>" .. keys, function()
			fn()
		end, { desc = desc })

		vim.keymap.set("n", "<leader>" .. uppered, "'<leader>" .. keys .. "' . \"\" . expand('<cword>')", {
			desc = desc,
			remap = true,
			expr = true,
		})

		vim.keymap.set("x", "<leader>" .. uppered, function()
			fn()
		end, { desc = desc })
		-- TODO: Temp with yanks hack until getregion is in stable.
		-- See: https://github.com/neovim/neovim/pull/27578
		vim.keymap.set(
			"x",
			"<leader>" .. keys,
			-- This is a hack too, since I couldn't find a way
			-- to feed keys in a blocking fashion consistently.
			'"zygv<leader>' .. keys .. "z",
			{
				desc = desc,
				remap = true,
			}
		)
	end

	map_under_cursor("fbb", function()
		require("telescope.builtin").buffers()
	end, "Find buffer")
	map_under_cursor("fbg", function()
		require("telescope.builtin").live_grep({ grep_open_files = true })
	end, "Find with grep in open buffers")
	map_under_cursor("fhf", function()
		require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
	end, "Find hidden files")
	map_under_cursor("fhg", function()
		require("telescope.builtin").live_grep({ hidden = true, no_ignore = true })
	end, "Find with grep")
	map_under_cursor("ff", function()
		require("telescope.builtin").find_files()
	end, "Find files")
	map_under_cursor("fkf", function()
		require("telescope.builtin").git_files()
	end, "Find git files")
	map_under_cursor("fkb", function()
		require("telescope.builtin").git_branches()
	end, "Find git branch")
	map_under_cursor("fg", function()
		require("telescope.builtin").live_grep()
	end, "Find with grep")
	map_under_cursor("fq", function()
		require("telescope.builtin").help_tags()
	end, "Find help")
	map_under_cursor("fr", function()
		require("telescope.builtin").oldfiles()
	end, "Find recent")
	map_under_cursor("fe", function()
		require("telescope.builtin").diagnostics()
	end, "Find diagnostics")
	vim.keymap.set("n", "<leader>fl", function()
		require("telescope.builtin").resume()
	end, { desc = "Last picker" })
end

function M:opts(_)
	-- Enable telescope fzf native, if installed
	pcall(require("telescope").load_extension, "fzf")
	return {}
end

return M
