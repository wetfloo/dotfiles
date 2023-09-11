return {
    'jinh0/eyeliner.nvim',
    keys = { 
        'f',
        'F',
        't',
        'T',
    },

    config = function()
        require('eyeliner').setup({
            highlight_on_key = true,
            dim = true,
        })

        vim.api.nvim_set_hl(0, 'EyelinerPrimary', { fg='#fa579c', bold = true, underline = false })
        vim.api.nvim_set_hl(0, 'EyelinerSecondary', { fg='#add149', bold = true, underline = false })
    end,
}
