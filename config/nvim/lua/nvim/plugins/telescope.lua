return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build =
            'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
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

        local builtin = require('telescope.builtin')

        local function map_under_cursor(keys, fn, desc)
            local uppered = (keys:gsub("(.)$", string.upper))
            vim.keymap.set(
                'n',
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
                builtin.find_files,
            'Find files'
        )
        map_under_cursor(
            'fk',
                builtin.git_files,
            'Find git files'
        )
        map_under_cursor(
            'fg',
                builtin.live_grep,
            'Find with grep'
        )
        map_under_cursor(
            'fb',
                builtin.buffers,
            'Find buffer'
        )

        vim.keymap.set(
            'n',
            '<leader>fl',
            builtin.resume,
            { desc = 'Last picker' }
        )
    end,
}
