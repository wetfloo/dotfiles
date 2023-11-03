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
        require('telescope').setup({
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

        local custom_pickers = require('nvim.plugins.utils.telescope_pickers')
        local builtin = require('telescope.builtin')

        vim.keymap.set(
            '',
            '<leader>ff',
            function()
                custom_pickers.pretty_files_picker({ picker = 'find_files' })
            end,
            { desc = 'Find files' }
        )
        vim.keymap.set(
            '',
            '<leader>fk',
            function()
                custom_pickers.pretty_files_picker({ picker = 'git_files' })
            end,
            { desc = 'Find git files' }
        )
        vim.keymap.set(
            '',
            '<leader>fg',
            function()
                custom_pickers.pretty_grep_picker({ picker = 'live_grep' })
            end,
            { desc = 'Find with grep' }
        )
        vim.keymap.set(
            '',
            '<leader>fb',
            function()
                custom_pickers.pretty_buffers_picker()
            end,
            { desc = 'Find buffer' }
        )
        vim.keymap.set(
            '',
            '<leader>fl',
            function()
                builtin.resume()
            end,
            { desc = 'Last picker' }
        )
    end,
}
