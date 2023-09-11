return {
    "gbprod/substitute.nvim",
    keys = {
        'cx',
    },
    event = { 
        'BufReadPost',
        'BufNewFile',
    },
    config = function(opts)
        require('substitute').setup({})
        local exchange = require('substitute.exchange')

        vim.keymap.set("n", "cx", exchange.operator, { noremap = true })
        vim.keymap.set("n", "cxx", exchange.line, { noremap = true })
        vim.keymap.set("n", "cxc", exchange.cancel, { noremap = true })
        vim.keymap.set("x", "X", exchange.visual, { noremap = true })
    end,
}
