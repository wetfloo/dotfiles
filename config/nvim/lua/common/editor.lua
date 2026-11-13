-- Must happen before plugins are required (otherwise wrong leader will be used)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Set highlight on search

vim.o.hlsearch = false
vim.o.incsearch = true

-- Save undo history

vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.timeout = true
vim.o.timeoutlen = 1000

-- Make visual line indentation less painful

vim.keymap.set("x", "<", "<gv", { desc = "Indent right" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent left" })

-- Yank/delete/change to the start of the line

vim.keymap.set("n", "<leader>Y", "y0`]", { desc = "Yank to the start of the line" })
vim.keymap.set("n", "<leader>C", "c0", { desc = "Change to the start of the line" })
vim.keymap.set("n", "<leader>D", "d0", { desc = "Delete to the start of the line" })

-- Plus register made convenient

vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to + register" })
vim.keymap.set({ "n", "x" }, "<leader>d", '"+d', { desc = "Delete to + register" })
vim.keymap.set({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from + register" })

-- Paste over the text without losing current unnamed register

vim.keymap.set("x", "p", '"_dp')
vim.keymap.set("x", "P", '"_dP')

vim.opt.guifont = "Iosevka Term,Iosevka Fixed,Iosevka,monospace"

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank({ timeout = 400 })
	end,
	pattern = "*",
})

vim.api.nvim_create_user_command("LineEndCleanup", [[%s/\s\+$//e]], {
	nargs = 0,
	desc = "remove",
})

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
	desc = "Disable New Line Comment",
})

vim.api.nvim_create_autocmd("ModeChanged", {
	group = vim.api.nvim_create_augroup("InsertModeEvents", { clear = true }),
	callback = function()
		local was_insert = vim.v.event.old_mode:sub(1, 1) == "i"
		local is_insert = vim.v.event.new_mode:sub(1, 1) == "i"

		if was_insert ~= is_insert then
			vim.api.nvim_exec_autocmds("User", {
				pattern = is_insert and "InsertModeEnter" or "InsertModeLeave",
				modeline = false,
			})
		end
	end,
})

local trailing_whitespace = vim.api.nvim_create_augroup("TrailingWhitespace", { clear = true })

local function hl_trailing_whitespace()
	return vim.w.trailing_whitespace_match or vim.fn.matchadd("TrailingWhitespace", [[\s\+$]])
end

vim.api.nvim_create_autocmd("User", {
	group = trailing_whitespace,
	pattern = { "InsertModeEnter" },
	callback = function()
		vim.w.trailing_whitespace_match = hl_trailing_whitespace()
	end,
})

vim.api.nvim_create_autocmd("User", {
	group = trailing_whitespace,
	pattern = { "InsertModeLeave" },
	callback = function()
		if vim.w.trailing_whitespace_match then
			vim.fn.matchdelete(vim.w.trailing_whitespace_match)
		end

		vim.w.trailing_whitespace_match = nil
	end,
})

vim.api.nvim_create_autocmd("WinEnter", {
	group = trailing_whitespace,
	callback = function()
		vim.w.trailing_whitespace_match = hl_trailing_whitespace()
	end,
})
