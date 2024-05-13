return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        -- Since we have a status line already, don't duplicate current mode display
        vim.o.showmode = false

        local separator = '::'
        local function buffer_not_empty()
            return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
        end

        local function diagnostic_symbol(sym)
            return sym .. ' '
        end

        local symbols = require('nvim.prefs').diagnostic_signs

        local ayu_status, _ = pcall(require, 'ayu')
        local noirbuddy_status, noirbuddy = pcall(require, 'noirbuddy.plugins.lualine')
        local theme
        if ayu_status then
            theme = 'ayu'
        elseif noirbuddy_status then
            theme = noirbuddy.theme
        else
            theme = 'auto'
        end

        require('lualine').setup(
            {
                options = {
                    icons_enabled = true,
                    theme = theme,
                    component_separators = separator,
                    section_separators = ' ',
                },
                sections = {
                    -- Left side.
                    lualine_a = {
                        'mode',
                    },
                    lualine_b = {},
                    lualine_c = {
                        {
                            'filename',
                            cond = buffer_not_empty,
                        },
                        {
                            'diagnostics',
                            symbols = {
                                error = diagnostic_symbol(symbols.Error),
                                warn = diagnostic_symbol(symbols.Warn),
                                info = diagnostic_symbol(symbols.Info),
                                ok = diagnostic_symbol(symbols.Ok),
                                hint = diagnostic_symbol(symbols.Hint),
                            },
                        },
                    },

                    -- Right side.
                    lualine_x = {
                        'diff',
                        'filetype',
                        {
                            'o:encoding',
                            fmt = string.lower,
                        },
                        {
                            'fileformat',
                            icons_enabled = false,
                        },
                        'location',
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
            }
        )
    end
}
