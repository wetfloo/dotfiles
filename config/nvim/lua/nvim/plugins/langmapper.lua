return {
    'Wansmer/langmapper.nvim',
    lazy = false,
    enabled = false,
    config = function()
        require('langmapper').setup({ global = true })
    end,
    priority = 1000,
}
