return {
    'j-hui/fidget.nvim',
    tag = 'v1.4.0',
    event = 'LspAttach',
    opts = {
        progress = {
            suppress_on_insert = true,
            display = {
                render_limit = 3,
            },
        },
    },
}
