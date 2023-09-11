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

-- 0 is more reachable than ^, is sometimes useful

vim.keymap.set('n', '0', '^')
vim.keymap.set('n', '^', '0')

-- Make visual line indentation less painful

vim.keymap.set('x', '<', '<gv', { desc = 'Indent right' })
vim.keymap.set('x', '>', '>gv', { desc = 'Indent left' })

-- Yank/delete/change to the start of the line

vim.keymap.set('n', '<leader>Y', 'y0`]', { desc = '[Y]ank to the start of the line' })
vim.keymap.set('n', '<leader>C', 'c0', { desc = '[C]hange to the start of the line' })
vim.keymap.set('n', '<leader>D', 'd0', { desc = '[D]elete to the start of the line' })

-- Plus register made convenient

vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = '[Y]ank to + register' })
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"+d', { desc = '[D]elete to + register' })
vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = '[P]aste from + register' })


-- Paste over the text without losing current unnamed register

vim.keymap.set('x', 'p', '"_dP')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ timeout = 1000 })
    end,
    group = highlight_group,
    pattern = '*',
})
