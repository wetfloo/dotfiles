return {
    'Shatur/neovim-ayu',
    lazy = false,
    priority = 1000,
    config = function()
        local colors = require('ayu.colors')
        colors.generate(false) -- Pass `true` to enable mirage

        require('ayu').setup({
            overrides = function()
                return {
                    Comment = { fg = colors.comment },
                }
            end,
        })

        require('ayu').colorscheme()
    end,
}
