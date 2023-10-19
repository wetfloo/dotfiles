return {
    'ThePrimeagen/harpoon',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },

    config = function()
        require('harpoon').setup(
            {
                -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
                save_on_toggle = false,

                -- saves the harpoon file upon every change. disabling is unrecommended.
                save_on_change = true,

                -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
                enter_on_sendcmd = false,

                -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
                tmux_autoclose_windows = false,

                -- filetypes that you want to prevent from adding to the harpoon list menu.
                excluded_filetypes = { "harpoon" },

                -- set marks specific to each git branch inside git repository
                mark_branch = false,

                -- enable tabline with harpoon marks (status line on the top)
                tabline = false,

                menu = {
                    width = vim.api.nvim_win_get_width(0) - 16,
                },
            }
        )

        local mark = require('harpoon.mark')
        local ui = require('harpoon.ui')

        vim.keymap.set('', '<leader>hh', function() mark.add_file() end, { desc = 'Add a bookmark' })
        vim.keymap.set('', '<leader>hd', function() mark.rm_file() end, { desc = 'Remove current file\'s bookmark' })
        vim.keymap.set('', '<leader>hD', mark.clear_all, { desc = 'Delete ALL bookmarks' })
        vim.keymap.set('', '<leader>hm', ui.toggle_quick_menu, { desc = 'Show bookmarks menu' })
        vim.keymap.set('', '<leader>hn', ui.nav_next, { desc = 'Next bookmark' })
        vim.keymap.set('', '<leader>hp', ui.nav_prev, { desc = 'Previous bookmark' })

        for i = 1, 9 do
            vim.keymap.set(
                '',
                '<leader>h' .. i,
                function() mark.set_current_at(i) end,
                { desc = 'Replace bookmark at ' .. i .. ' with the current file' }
            )

            vim.keymap.set(
                'n',
                '<A-' .. i .. '>',
                function()
                    ui.nav_file(i)
                end,
                { desc = 'Go to bookmark' .. 'i' }
            )
        end

        -- Doesn't work properly, for some reason
        -- require('telescope').load_extension('harpoon')
    end,
}
