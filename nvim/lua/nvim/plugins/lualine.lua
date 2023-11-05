local function eviline_cfg()
    local flavor = require('nvim.prefs').catppuccin_flavor
    local colors = require('catppuccin.palettes').get_palette(flavor)
    local prefs = require('nvim.prefs')
    local lualine = require('lualine')

    local conditions = {
        buffer_not_empty = function()
            return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
        end,

        hide_in_width = function()
            return vim.fn.winwidth(0) > 80
        end,

        check_git_workspace = function()
            local filepath = vim.fn.expand('%:p:h')
            local gitdir = vim.fn.finddir('.git', filepath .. ';')
            return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
    }

    -- Config
    local config = {
        options = {
            -- Disable sections and component separators
            component_separators = '',
            section_separators = '',
        },
        sections = {
            -- these are to remove the defaults
            lualine_a = {},
            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            -- These will be filled later
            lualine_c = {},
            lualine_x = {},
        },
        inactive_sections = {
            -- these are to remove the defaults
            lualine_a = {},
            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            lualine_c = {},
            lualine_x = {},
        },
    }

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x at right section
    local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
    end

    ins_left(
        {
            'mode',
            padding = { left = 2 },
        }
    )

    ins_left(
        {
            'filename',
            cond = conditions.buffer_not_empty,
            color = { fg = colors.lavender, gui = 'bold' },
        }
    )

    ins_left({ 'location' })

    local prefs_diagnostic_signs = prefs.diagnostic_signs
    for _, v in pairs(prefs_diagnostic_signs) do
        prefs_diagnostic_signs.k = v .. ' '
    end
    local symbols = {
        error = prefs_diagnostic_signs.Error,
        warn = prefs_diagnostic_signs.Warn,
        info = prefs_diagnostic_signs.Info,
        hint = prefs_diagnostic_signs.Hint,
    }
    ins_left(
        {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = symbols,
            diagnostics_color = {
                color_error = { fg = colors.red },
                color_warn = { fg = colors.yellow },
                color_info = { fg = colors.sky },
            },
        }
    )

    -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater then 2
    ins_left(
        {
            function()
                return '%='
            end,
        }
    )

    ins_left(
        {
            -- Lsp server name .
            function()
                local msg = 'No Active Lsp'
                local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                local clients = vim.lsp.get_active_clients()
                if next(clients) == nil then
                    return msg
                end
                for _, client in ipairs(clients) do
                    local filetypes = client.config.filetypes
                    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                        return client.name
                    end
                end
                return msg
            end,
            icon = ' LSP:',
            color = { fg = '#ffffff', gui = 'bold' },
        }
    )

    -- Add components to right sections
    ins_right(
        {
            'o:encoding', -- option component same as &encoding in viml
            fmt = string.lower,
            cond = conditions.hide_in_width,
            color = { fg = colors.green, gui = 'bold' },
        }
    )

    ins_right {
        'fileformat',
        fmt = string.lower,
        icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
        color = { fg = colors.green, gui = 'bold' },
    }

    ins_right {
        'branch',
        icon = '',
        color = { fg = colors.lavender, gui = 'bold' },
    }

    ins_right {
        'diff',
        symbols = prefs.git_signs,
        diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.yellow },
            removed = { fg = colors.red },
        },
        cond = conditions.hide_in_width,
    }

    ins_right {
        function()
            return '▊'
        end,
        color = { fg = colors.blue },
        padding = { left = 1 },
    }

    -- Now don't forget to initialize lualine
    lualine.setup(config)
end

local function my_cfg()
    require('lualine').setup(
        {
            options = {
                icons_enabled = false,
                theme = 'auto',
                component_separators = '|',
                section_separators = '',
            },
            sections = {
                lualine_a = {
                    'mode',
                },
                lualine_b = {
                    'filename',
                    'branch',
                },
                lualine_c = {
                    'lsp_progress',
                },

                lualine_x = {},
            },
        }
    )
end

return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        -- Since we have a status line already, don't duplicate current mode display

        vim.o.showmode = false

        my_cfg()
    end
}
