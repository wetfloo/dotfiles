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

vim.keymap.set("x", "p", '"_dP')

local yank_highlight = vim.api.nvim_create_augroup("yank_highlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 400 })
    end,
    group = yank_highlight,
    pattern = "*",
})

local clear_trailing_space = vim.api.nvim_create_augroup("clear_trailing_space", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    command = [[%s/\s\+$//e]],
    group = clear_trailing_space,
    pattern = "*",
})
