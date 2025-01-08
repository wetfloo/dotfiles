return {
    "j-hui/fidget.nvim",
    tag = "v1.5.0",
    event = "LspAttach",
    opts = {
        notification = {
            window = {
                winblend = 0,
            },
        },
        progress = {
            suppress_on_insert = true,
            display = {
                render_limit = 3,
            },
        },
    },
}
