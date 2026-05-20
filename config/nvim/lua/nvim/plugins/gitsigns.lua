--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"lewis6991/gitsigns.nvim",
}

M.event = {
	"User RealFileOpen",
}

M.lazy = true

function M:init()
	local function map(keys, func, desc, mode_override)
		local mode
		if mode_override ~= nil then
			mode = mode_override
		else
			mode = "n"
		end

		if desc ~= nil then
			desc = desc .. " (git)"
		end

		vim.keymap.set(mode, "<leader>" .. keys, func, { buffer = 0, desc = desc })
	end

	-- Navigation
	map("kp", function()
		require("gitsigns").nav_hunk("prev")
	end, "Go to previous hunk")
	map("kn", function()
		require("gitsigns").nav_hunk("next")
	end, "Go to next hunk")

	-- Actions
	map("ks", function()
		require("gitsigns").stage_hunk()
	end, "Stage hunk", "n")
	map("kXh", function()
		require("gitsigns").reset_hunk()
	end, "Reset hunk", "n")
	-- It's important to keep these here to override all-mode stage and reset mappings above.
	map("ks", function()
		require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, "Stage hunk", "x")
	map("kXh", function()
		require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, "Reset hunk", "x")
	map("kS", function()
		require("gitsigns").stage_buffer()
	end, "Stage buffer")
	map("kXb", function()
		require("gitsigns").reset_buffer()
	end, "Reset buffer")
	map("kr", function()
		require("gitsigns").preview_hunk()
	end, "Preview hunk")
	map("kv", function()
		require("gitsigns").blame_line({ full = true })
	end, "Blame line")
	map("kB", function()
		require("gitsigns").toggle_current_line_blame()
	end, "Toggle current line blame")
	map("kc", function()
		require("gitsigns").diffthis()
	end, "Diff this")
	map("kC", function()
		require("gitsigns").diffthis("~")
	end, "Diff this to one commit ago")
end

return M
