return {
    'kylechui/nvim-surround',
    version = '*',
    event = { 
        'BufReadPost',
        'BufNewFile',
    },

    -- This empty table is necessary, otherwise it doesn't run.

    opts = {},
}
