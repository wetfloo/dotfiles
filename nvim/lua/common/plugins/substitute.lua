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

        vim.keymap.set('n', 'cx', exchange.operator, { desc = 'Substitute text object'})
        vim.keymap.set('n', 'cxx', exchange.line, { desc = 'Substitute current line '})
        vim.keymap.set('n', 'cxc', exchange.cancel, { desc = 'Cancel substitute'})
        vim.keymap.set('x', '<leader>X', exchange.visual, { desc = 'Substitute selection'})
    end,
}
