return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
    },
    config = function()
        require('telescope').setup ({
            defaults = {
                mappings = {
                    i = {
                        ['<C-u>'] = false,
                        ['<C-d>'] = false,
                    },
                },
            },
        })
        local telescope = require('telescope.builtin')

        vim.keymap.set({ 'n' }, '<leader>ff', telescope.find_files, { desc = '[F]ind [F]iles' })
        vim.keymap.set({ 'n' }, '<leader>fg', telescope.live_grep, { desc = '[F]ind by [G]rep' })
    end,
}
