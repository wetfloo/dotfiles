return {
    'jesseleite/nvim-noirbuddy',
    dependencies = {
        { 'tjdevries/colorbuddy.nvim', branch = 'dev' }
    },
    lazy = false,
    priority = 1000,
    opts = {
        colors = {
            primary = '#d197fc',
            secondary = '#a7d2fa',
            background = '#000000',
        }
    },
}
