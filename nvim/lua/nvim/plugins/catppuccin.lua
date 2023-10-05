return {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000, -- Needs to be loaded before anything else happens.
    term_colors = true,
    config = function()
        require('catppuccin').setup(
            {
                transparent_background = not vim.g.started_by_firenvim,
                flavour = require('nvim.prefs').catppuccin_flavor(),
                show_end_of_buffer = false,
                integrations = {
                    cmp = true,
                    telescope = true,
                    neotree = true,
                    treesitter = true,
                    harpoon = true,
                    mason = true,
                    leap = true,
                    indent_blankline = true,
                    gitsigns = true,
                    ufo = true,
                    which_key = true,
                    dap = {
                        enabled = true,
                        enabled_ui = true,
                    },
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        underlines = {
                            errors = { "undercurl" },
                            hints = { "underdashed" },
                            warnings = { "undercurl" },
                            information = { "underdashed" },
                        },
                    },
                },
            }
        )

        -- Set the theme after setting it up.
        vim.cmd.colorscheme 'catppuccin'
    end
}
