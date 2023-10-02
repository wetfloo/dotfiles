local function modes(key)
    return { key, mode = { 'n', 'x', 'o' } }
end

return {
    'jinh0/eyeliner.nvim',
    keys = {
        modes('f'),
        modes('F'),
        modes('t'),
        modes('T'),
    },
    config = function()
        require('eyeliner').setup({
            highlight_on_key = true,
            dim = true,
        })

        vim.api.nvim_set_hl(0, 'EyelinerPrimary', { fg = '#fa579c', bold = true, underline = false })
        vim.api.nvim_set_hl(0, 'EyelinerSecondary', { fg = '#add149', bold = true, underline = false })
    end,
}
