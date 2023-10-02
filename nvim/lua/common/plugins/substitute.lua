local leader_prefix = require('utils').leader_prefix

return {
    'gbprod/substitute.nvim',
    keys = {
        { 'cx', mode = 'n' },
        { leader_prefix('X'), mode = 'x' },
    },
    config = function()
        require('substitute').setup({})
        local exchange = require('substitute.exchange')

        vim.keymap.set('n', 'cx', exchange.operator, { noremap = true })
        vim.keymap.set('n', 'cxx', exchange.line, { noremap = true })
        vim.keymap.set('n', 'cxc', exchange.cancel, { noremap = true })
        vim.keymap.set('x', '<leader>X', exchange.visual, { noremap = true })
    end,
}
