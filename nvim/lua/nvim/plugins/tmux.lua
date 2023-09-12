return {
    'aserowy/tmux.nvim',

    config = function()
        local tmux = require('tmux')

        tmux.setup({
            resize = {

                -- The defaults are A-hjkl, which is not what I want.

                enable_default_keybindings = false,
            },
        })

        vim.keymap.set(
            { 'n', 'x' },
            '<A-a>',
            function()
                tmux.resize_left()
            end
        )

        vim.keymap.set(
            { 'n', 'x' },
            '<A-f>',
            function()
                tmux.resize_right()
            end
        )

        vim.keymap.set(
            { 'n', 'x' },
            '<A-s>',
            function()
                tmux.resize_bottom()
            end
        )

        vim.keymap.set(
            { 'n', 'x' },
            '<A-d>',
            function()
                tmux.resize_top()
            end
        )

    end,
}
