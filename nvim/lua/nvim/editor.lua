-- Avoid weird 8 space tabs

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- NOTE: You should make sure your terminal supports this

vim.o.termguicolors = true

-- Since we have a status line already, don't duplicate current mode display

vim.o.showmode = false

-- Visual editor stuff: no line wraps, scrolloff, relative line numbers

vim.o.wrap = false
vim.o.scrolloff = 5
vim.wo.number = true
vim.wo.relativenumber = true

-- Keep signcolumn on by default

vim.wo.signcolumn = 'yes'

-- Disable netrw, since I'm using neotree

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Meme remap

vim.keymap.set('', '<C-c>', '<Esc>')
vim.keymap.set('', '<Esc>', '<C-c>')

-- Making it more comfortable to work with mutliple splits.
-- The rest of keybinds are provided by the tmux plugin.

vim.keymap.set({ 'n', 'x' }, '<leader>dv', '<C-w>v', { desc = 'Divide (split) vertically' })
vim.keymap.set({ 'n', 'x' }, '<leader>dh', '<C-w>s', { desc = 'Divide (split) horizontally' })

-- Move around buffers as if they're tabs

vim.keymap.set('n', '<A-,>', ':bprev<CR>', { desc = 'Go to the previous buffer', silent = true })
vim.keymap.set('n', '<A-.>', ':bnext<CR>', { desc = 'Go to the next buffer', silent = true })
vim.keymap.set('n', '<A-d>', ':Bdelete<CR>', { desc = 'Delete the current buffer', silent = true })
vim.keymap.set('n', '<A-D>', ':Bwipeout<CR>', { desc = 'Wipe out the current buffer', silent = true })

-- Remap for dealing with word wrap

vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move selected stuff around

vim.keymap.set('n', '<A-p>', ":mo -2<CR>", { desc = "Move current line one line up", silent = true })
vim.keymap.set('n', '<A-n>', ":mo +1<CR>", { desc = "Move current line one line down", silent = true })
vim.keymap.set('x', '<A-p>', ":'<,'> mo -2<CR>gv=gv", { desc = "Move selection one line up", silent = true })
vim.keymap.set('x', '<A-n>', ":'<,'> mo '>+<CR>gv=gv", { desc = "Move selection one line down", silent = true })

--- Centers the view after moving using 'zz'
local function move_and_center(mode, action, opts)
    vim.keymap.set(mode, action, action .. 'zz', opts)
end

move_and_center({ 'n', 'x' }, '<C-d>')
move_and_center({ 'n', 'x' }, '<C-u>')
move_and_center({ 'n', 'x' }, '<C-b>')
move_and_center({ 'n', 'x' }, '<C-f>')
move_and_center({ 'n', 'x' }, 'n')
move_and_center({ 'n', 'x' }, 'N')

-- :help diagnostic-highlights
vim.diagnostic.config(
    {
        virtual_text = {
            severity = vim.diagnostic.severity.ERROR,
        },
    }
)

-- Define signs on the left for diagnostics.

local signs = require('nvim.prefs').diagnostic_signs
for type, icon in pairs(signs) do
    local highlight = 'DiagnosticSign' .. type
    vim.fn.sign_define(highlight, { text = icon, texthl = highlight, numhl = '', })
end
