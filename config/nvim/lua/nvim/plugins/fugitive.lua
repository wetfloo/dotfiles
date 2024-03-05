return {
    'tpope/vim-fugitive',
    event = {
        'VeryLazy',
    },
    config = function()
        vim.keymap.set(
            'n',
            '<leader>kb',
            function()
                vim.cmd('G blame')
            end,
            { desc = 'Show git blame side window (git)' }
        )
    end,
}
