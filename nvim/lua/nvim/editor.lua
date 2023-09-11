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

-- Change empty line chars

vim.opt.fillchars = { eob = '*' }

-- Making it more comfortable to work with mutliple splits

vim.keymap.set({ 'n', 'x' }, '<leader>dv', '<C-w>v', { desc = '[D]ivide (split) vertically' })
vim.keymap.set({ 'n', 'x' }, '<leader>dh', '<C-w>s', { desc = '[D]ivide (split) horizontally' })
vim.keymap.set({ 'n', 'x' }, '<C-k>', '<C-w>k', { desc = 'To split above' })
vim.keymap.set({ 'n', 'x' }, '<C-j>', '<C-w>j', { desc = 'To split below' })
vim.keymap.set({ 'n', 'x' }, '<C-h>', '<C-w>h', { desc = 'To split on the left' })
vim.keymap.set({ 'n', 'x' }, '<C-l>', '<C-w>l', { desc = 'To split on the right' })

-- Move between tabs more easily

vim.keymap.set({ 'n', 'x' }, '<A-l>', ':bnext<CR>', { silent = true })
vim.keymap.set({ 'n', 'x' }, '<A-h>', ':bprev<CR>', { silent = true })
vim.keymap.set({ 'n', 'x' }, '<A-d>', ':bdelete<CR>', { silent = true })

-- Move around buffers as if they're tabs

vim.keymap.set('n', '<A-h>', ':bprev<CR>', { desc = 'Go to the previous buffer', silent = true })
vim.keymap.set('n', '<A-l>', ':bnext<CR>', { desc = 'Go to the next buffer', silent = true })
vim.keymap.set('n', '<A-d>', ':Bdelete<CR>', { desc = 'Delete the current buffer', silent = true })
vim.keymap.set('n', '<A-D>', ':Bwipeout<CR>', { desc = 'Wipe out the current buffer', silent = true })

-- Open up a file explorer

vim.keymap.set('n', '<leader>tt', ':Neotree action=focus<CR>', { desc = 'Neotree focus', silent = true })
vim.keymap.set('n', '<leader>tu', ':UndotreeShow<CR> :UndotreeFocus<CR>', { desc = 'Undotree focus', silent = true })

-- Remap for dealing with word wrap

vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move selected stuff around

vim.keymap.set('n', '<A-p>', ":mo -2<CR>", { desc = "Move selection one line up", silent = true })
vim.keymap.set('n', '<A-n>', ":mo +1<CR>", { desc = "Move selection one line down", silent = true  })
vim.keymap.set('x', '<A-p>', ":'<,'> mo -2<CR>gv=gv", { desc = "Move selection one line up", silent = true  })
vim.keymap.set('x', '<A-n>', ":'<,'> mo '>+<CR>gv=gv", { desc = "Move selection one line down", silent = true  })
