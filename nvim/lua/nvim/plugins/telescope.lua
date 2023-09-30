return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.3',
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

        -- Enable telescope fzf native, if installed

        pcall(require('telescope').load_extension, 'fzf')

        vim.keymap.set({ 'n' }, '<leader>ff', require('telescope.builtin').find_files, { desc = 'Find files' })
        vim.keymap.set({ 'n' }, '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Find with grep' })
    end,
}
