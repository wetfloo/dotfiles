return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
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
            pickers = {
                oldfiles = {
                    cwd_only = true,
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

            vim.keymap.set(
                'x',
                '<leader>' .. uppered,
                fn,
                { desc = desc }
            )
            -- TODO: Temp with yanks hack until getregion is in stable.
            -- See: https://github.com/neovim/neovim/pull/27578
            vim.keymap.set(
                'x',
                '<leader>' .. keys,
                -- This is a hack too, since I couldn't find a way
                -- to feed keys in a blocking fashion consistently.
                '"zygv<leader>' .. keys .. 'z',
                {
                    desc = desc,
                    remap = true,
                }
            )
        end

        map_under_cursor(
            'fbb',
            builtin.buffers,
            'Find buffer'
        )
        map_under_cursor(
            'fbg',
            function()
                builtin.live_grep({ grep_open_files = true })
            end,
            'Find with grep in open buffers'
        )
        map_under_cursor(
            'fhf',
            function()
                builtin.find_files({ hidden = true, no_ignore = true })
            end,
            'Find hidden files'
        )

        map_under_cursor(
            'ff',
            builtin.find_files,
            'Find files'
        )
        map_under_cursor(
            'fkf',
            builtin.git_files,
            'Find git files'
        )
        map_under_cursor(
            'fkb',
            builtin.git_branches,
            'Find git branch'
        )
        map_under_cursor(
            'fg',
            builtin.live_grep,
            'Find with grep'
        )
        map_under_cursor(
            'fq',
            builtin.help_tags,
            'Find help'
        )
        map_under_cursor(
            'fr',
            builtin.oldfiles,
            'Find recent'
        )
        map_under_cursor(
            'fe',
            builtin.diagnostics,
            'Find diagnostics'
        )

        vim.keymap.set(
            'n',
            '<leader>fl',
            builtin.resume,
            { desc = 'Last picker' }
        )
    end,
}
