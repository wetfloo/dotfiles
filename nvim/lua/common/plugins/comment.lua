return { 
    'numToStr/Comment.nvim',
    keys = { 
        'gc',
    },
    event = { 
        'BufReadPost',
        'BufNewFile',
    },

    -- This empty table is necessary, otherwise it doesn't run.

    opts = {},
}
