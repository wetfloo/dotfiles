-- Must happen before plugins are required (otherwise wrong leader will be used)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

vim.keymap.set(
    { 'n', 'v' },
    '<Space>',
    '<Nop>',
    { silent = true }
)


-- Set highlight on search

vim.o.hlsearch = false
vim.o.incsearch = true

-- Save undo history

vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search

vim.o.ignorecase = true
vim.o.smartcase = true

-- Make visual line indentation less painful

vim.keymap.set('x', '<', '<gv', { desc = 'Indent right' })
vim.keymap.set('x', '>', '>gv', { desc = 'Indent left' })

-- Yank/delete/change to the start of the line

vim.keymap.set('n', '<leader>Y', 'y0`]', { desc = 'Yank to the start of the line' })
vim.keymap.set('n', '<leader>C', 'c0', { desc = 'Change to the start of the line' })
vim.keymap.set('n', '<leader>D', 'd0', { desc = 'Delete to the start of the line' })

-- Plus register made convenient

vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to + register' })
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"+d', { desc = 'Delete to + register' })
vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste from + register' })


-- Paste over the text without losing current unnamed register

vim.keymap.set('x', 'p', '"_dP')

local augroup = require('common.prefs').augroup
vim.api.nvim_create_autocmd(
    'TextYankPost',
    {
        callback = function()
            vim.highlight.on_yank({ timeout = 400 })
        end,
        group = augroup,
        pattern = '*',
    }
)

vim.api.nvim_create_autocmd(
    'BufWritePre',
    {
        command = [[%s/\s\+$//e]],
        group = augroup,
        pattern = '*',
    }
)

vim.api.nvim_create_autocmd(
    'BufWritePost',
    {
        pattern = { "*.tex" },
        command = [[call jobstart('xelatex main.tex && biber main.tex && xelatex main.tex')]],
        group = augroup,
    }
)
