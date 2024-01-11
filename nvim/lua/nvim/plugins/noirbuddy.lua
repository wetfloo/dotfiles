return {
    'jesseleite/nvim-noirbuddy',
    dependencies = {
        { 'tjdevries/colorbuddy.nvim', branch = 'dev' }
    },
    lazy = false,
    priority = 1000,
    opts = {
        colors = {
            primary = '#b361f2',
            secondary = '#a7d2fa',
            background = '#080808',
        }
    },
}
