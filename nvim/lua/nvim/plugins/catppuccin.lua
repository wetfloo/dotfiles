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
                        -- rosewater = '#fcdbd5', -- #f5e0dc
                        -- flamingo = '#fdc4c4', -- #f2cdcd
                        -- pink = '#feb9eb',     -- #f5c2e7
                        -- mauve = '#b070ff',    -- #cba6f7
                        -- red = '#fd638f',      -- #f38ba8
                        -- maroon = '#f87288',   -- #eba0ac
                        -- peach = '#fea771',    -- #fab387
                        -- yellow = '#ffdd94',   -- #f9e2af
                        -- green = '#87fe7c',    -- #a6e3a1
                        -- teal = '#51fbde',     -- #94e2d5
                        -- sky = '#52e4fe',      -- #89dceb
                        -- sapphire = '#46c2fb', -- #74c7ec
                        -- blue = '#5c9aff',     -- #89b4fa
                        -- lavender = '#8a99ff', -- #b4befe
                        text = '#eef1fc',     -- #cdd6f4
                        subtext1 = '#cbd1e6', -- #bac2de
                        subtext0 = '#b6bcd2', -- #a6adc8
                        base = '#0f0f18',     -- #1e1e2e
                        mantle = '#0c0c13',   -- #181825
                        crust = '#000000',    -- #11111b
                        surface0 = '#1a1b23', -- #313244
                        surface1 = '#22232f', -- #45475a
                        surface2 = '#2c2e3a', -- #585b70
                        overlay0 = '#292a33', -- #6c7086
                        overlay1 = '#393b47', -- #7f849c
                        overlay2 = '#464958', -- #9399b2
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
        vim.cmd.colorscheme('catppuccin')
    end
}
