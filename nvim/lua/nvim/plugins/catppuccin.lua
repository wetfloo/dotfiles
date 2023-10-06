return {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000, -- Needs to be loaded before anything else happens.
    term_colors = true,
    config = function()
        require('catppuccin').setup(
            {
                -- transparent_background = not vim.g.started_by_firenvim,
                transparent_background = false,
                flavour = require('nvim.prefs').catppuccin_flavor(),
                show_end_of_buffer = false,
                color_overrides = {
                    mocha = {
                        base = '#14141f',     -- #1e1e2e
                        mantle = '#101019',   -- #181825
                        crust = '#0c0c13',    -- #11111b
                        surface0 = '#22232f', -- #313244
                        surface1 = '#2c2e3a', -- #45475a
                        surface2 = '#3a3c4a', -- #585b70
                        overlay0 = '#464958', -- #6c7086
                        overlay1 = '#52566b', -- #7f849c
                        overlay2 = '#5b6280', -- #9399b2
                    },
                },
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
