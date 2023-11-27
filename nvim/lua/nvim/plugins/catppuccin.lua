return {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000, -- Needs to be loaded before anything else happens.
    config = function()
        require('catppuccin').setup(
            {
                flavour = require('nvim.prefs').catppuccin_flavor,
                show_end_of_buffer = false,
                color_overrides = {
                    mocha = {
                        rosewater = '#f5e0dc', -- #f5e0dc
                        flamingo = '#f2cdcd', -- #f2cdcd
                        pink = '#f5c2e7',     -- #f5c2e7
                        mauve = '#cba6f7',    -- #cba6f7
                        red = '#f38ba8',      -- #f38ba8
                        maroon = '#eba0ac',   -- #eba0ac
                        peach = '#fab387',    -- #fab387
                        yellow = '#f9e2af',   -- #f9e2af
                        green = '#a6e3a1',    -- #a6e3a1
                        teal = '#94e2d5',     -- #94e2d5
                        sky = '#89dceb',      -- #89dceb
                        sapphire = '#74c7ec', -- #74c7ec
                        blue = '#89b4fa',     -- #89b4fa
                        lavender = '#b4befe', -- #b4befe
                        text = '#cdd6f4',     -- #cdd6f4
                        subtext1 = '#bac2de', -- #bac2de
                        subtext0 = '#a6adc8', -- #a6adc8
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
                    dap = {
                    },
                    native_lsp = {
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
