return {
    'mbbill/undotree',
    event = 'VeryLazy',
    config = function()
        vim.keymap.set(
            'n',
            '<leader>tu',
            function()
                vim.cmd('UndotreeToggle')
            end,
            { desc = 'Undotree toggle', }
        )
    end,
}
