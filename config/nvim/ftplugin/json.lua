local prefs = require('nvim.prefs')

vim.keymap.set(
    { 'n', 'x' },
    prefs.keymaps.validate,
    ':w !jq . > /dev/null<CR>',
    { silent = false }
)
