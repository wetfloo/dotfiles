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
            }
        )
        local mark = require('harpoon.mark')
        local ui = require('harpoon.ui')

        vim.keymap.set('n', '<leader>hh', mark.add_file)
        vim.keymap.set('n', '<leader>hm', ui.toggle_quick_menu)
        vim.keymap.set('n', '<leader>hn', ui.nav_next)
        vim.keymap.set('n', '<leader>hp', ui.nav_prev)
        for i = 1, 9 do
            local function nav()
                ui.nav_file(i)
            end
            vim.keymap.set('n', '<leader>h' .. i, nav)
        end
    end,
}
