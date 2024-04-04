return {
    'jesseleite/nvim-noirbuddy',
    dependencies = {
        { 'tjdevries/colorbuddy.nvim', branch = 'master' }
    },
    lazy = false,
    priority = 1000,
    opts = {
        colors = {
            primary = '#dfb6fc',
            secondary = '#a7d2fa',
            background = '#000000',

            diagnostic_error = '#ff6666',
            diagnostic_warning = '#fff98f',
            diagnostic_info = '#b3f9ff',
            diagnostic_hint = '#b3d1ff',

            diff_add = '#80ff91',
            diff_change = '#a7d2fa',
            diff_delete = '#ff6666',
        }
    },
}
