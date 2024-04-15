-- Avoid weird 8 space tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Visual editor stuff: line wraps, scrolloff, relative line numbers
vim.o.wrap = true
vim.o.scrolloff = 0
vim.wo.number = true
vim.wo.relativenumber = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Disable netrw, since I'm using neotree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.cursorline = true
vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkon500'

vim.opt.updatetime = 500
vim.opt.inccommand = 'nosplit'

vim.o.spell = true
vim.o.spelllang = 'ru_ru,en_us'

vim.keymap.set('', '<C-c>', '<Esc>')
vim.keymap.set('', '<F1>', '<Nop>')
vim.keymap.set('!', '<F1>', '<Nop>')

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.keymap.set(
    'n',
    '<leader>qq',
    function()
        -- Currently open windows
        local wins = vim.api.nvim_list_wins()
        -- Their respective buffers
        local bufs = {}
        for _, win in ipairs(wins) do
            bufs[win] = vim.api.nvim_win_get_buf(win)
        end
        -- Find quickfix buffer handle
        local qf_win = nil
        for win, buf in pairs(bufs) do
            local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
            if filetype == 'qf' then
                qf_win = win
            end
        end

        if qf_win ~= nil then
            vim.api.nvim_win_close(qf_win, false)
        else
            vim.cmd('copen')
        end
    end,
    { desc = 'Toggle quickfix window' })

local function qfmove(mode, lhs, fn, opts)
    vim.keymap.set(
        mode,
        lhs,
        function()
            ---@diagnostic disable-next-line: param-type-mismatch
            local ok, _ = pcall(fn)
            if not ok then
                print('No more quickfix entries')
            end
        end,
        opts
    )
end

qfmove('n', '<leader>qp', function() vim.cmd('cprev') end, { desc = 'Previous quickfix entry' })
qfmove('n', '<leader>qn', function() vim.cmd('cnext') end, { desc = 'Next quickfix entry' })

-- Making it more comfortable to work with mutliple splits.
-- The rest of keybinds are provided by the tmux plugin.
vim.keymap.set('n', '<leader>dv', '<C-w>v', { desc = 'Divide (split) vertically' })
vim.keymap.set('n', '<leader>dh', '<C-w>s', { desc = 'Divide (split) horizontally' })
vim.keymap.set('n', '<leader>du', function() vim.cmd('on') end, { desc = 'Close all other windows (unsplit)' })

-- Move around buffers as if they're tabs
vim.keymap.set('n', '<A-,>', ':bprev<CR>', { desc = 'Go to the previous buffer', silent = true })
vim.keymap.set('n', '<A-.>', ':bnext<CR>', { desc = 'Go to the next buffer', silent = true })
vim.keymap.set('n', '<A-d>', ':Bdelete<CR>', { desc = 'Delete the current buffer', silent = true })
vim.keymap.set('n', '<A-D>', ':Bwipeout<CR>', { desc = 'Wipe out the current buffer', silent = true })

-- Remap for dealing with word wrap
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gkzz' : 'k'", { expr = true, silent = true })
-- vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gjzz' : 'j'", { expr = true, silent = true })
-- vim.keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gkzz' : 'k'", { expr = true, silent = true })
-- vim.keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gjzz' : 'j'", { expr = true, silent = true })

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
move_and_center({ 'n', 'x' }, 'gg')
move_and_center({ 'n', 'x' }, 'G')

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
