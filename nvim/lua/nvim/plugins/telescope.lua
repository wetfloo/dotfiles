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

        local function map_under_cursor(keys, fn, desc)
            local uppered = (keys:gsub("(.)$", string.upper))
            vim.keymap.set(
                { 'n', 'x' },
                '<leader>' .. keys,
                fn,
                { desc = desc }
            )

            vim.keymap.set(
                'n',
                '<leader>' .. uppered,
                '\'<leader>' .. keys .. '\' . "" . expand(\'<cword>\')',
                {
                    desc = desc,
                    remap = true,
                    expr = true,
                }
            )
        end

        map_under_cursor(
            'ff',
            function()
                custom_pickers.pretty_files_picker({ picker = 'find_files' })
            end,
            'Find files'
        )
        map_under_cursor(
            'fk',
            function()
                custom_pickers.pretty_files_picker({ picker = 'git_files' })
            end,
            'Find git files'
        )
        map_under_cursor(
            'fg',
            function()
                custom_pickers.pretty_grep_picker({ picker = 'live_grep' })
            end,
            'Find with grep'
        )
        map_under_cursor(
            'fb',
            function()
                custom_pickers.pretty_buffers_picker()
            end,
            'Find buffer'
        )

        vim.keymap.set(
            { 'n', 'x' },
            '<leader>fl',
            function()
                builtin.resume()
            end,
            { desc = 'Last picker' }
        )
    end,
}
