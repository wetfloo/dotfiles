return {
    'lukas-reineke/indent-blankline.nvim',
    enabled = false,
    event = {
        'BufReadPost',
        'BufNewFile',
    },
    main = 'ibl',
    opts = {
        indent = {
            highlight = { "LineNr" },
            -- char = '',
        },
        scope = { enabled = false },
        exclude = {
            filetypes = {
                "help",
                "*oil*",
                "lazy",
                "asm",
                "",
            },
        },
    },
}
