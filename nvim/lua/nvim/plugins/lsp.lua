return {
    'neovim/nvim-lspconfig',
    dependencies = {
        {
            'williamboman/mason.nvim',

            -- Uses the defeault implementation

            config = true,
        },
        'williamboman/mason-lspconfig.nvim',


        'folke/neodev.nvim',
        {
            'lewis6991/gitsigns.nvim',
            opts = {},
        },
    },
}
