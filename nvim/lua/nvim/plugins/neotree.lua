-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
    'nvim-neo-tree/neo-tree.nvim',
    version = 'v3.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
        {
            's1n7ax/nvim-window-picker',
            version = '2.*',
            config = function()
                require('window-picker').setup(
                    {
                        filter_rules = {
                            include_current_win = false,
                            autoselect_one = true,

                            -- filter using buffer options

                            bo = {
                                -- if the file type is one of following, the window will be ignored

                                filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                                -- if the buffer type is one of following, the window will be ignored

                                buftype = { 'terminal', "quickfix" },
                            },
                        },
                    }
                )
            end,
        }
    },
    config = function()
        -- If you want icons for diagnostic errors, you'll need to define them somewhere:

        vim.fn.sign_define(
            "DiagnosticSignError",
            { text = " ", texthl = "DiagnosticSignError" }
        )
        vim.fn.sign_define(
            "DiagnosticSignWarn",
            { text = " ", texthl = "DiagnosticSignWarn" }
        )
        vim.fn.sign_define(
            "DiagnosticSignInfo",
            { text = " ", texthl = "DiagnosticSignInfo" }
        )
        vim.fn.sign_define(
            "DiagnosticSignHint",
            { text = "󰌵", texthl = "DiagnosticSignHint" }
        )

        require('neo-tree').setup(
            {
                close_if_last_window = true,
                indent = {
                    indent_marker = '',
                },
                icon = {
                    folder_closed = "󰉋",
                    folder_open = "󰝰",
                    folder_empty = "󰉘",

                    -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                    -- then these will never be used.

                    default = "",
                    highlight = "NeoTreeFileIcon",
                }
            }
        )

        vim.keymap.set('n', '<leader>tt', ':Neotree action=focus<CR>', { desc = 'Neotree focus', silent = true })
    end
}
