local ftplugin_keymap = require("nvim.keymap").ftplugin

ftplugin_keymap.validate:map(":w !jq . > /dev/null<CR>", { silent = true })
