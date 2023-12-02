local function my_cfg()
    local separator = '::'
    local function buffer_not_empty()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end

    require('lualine').setup(
        {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = separator,
                section_separators = ' ',
            },
            sections = {
                lualine_a = {
                    'mode',
                },
                lualine_b = {},
                lualine_c = {
                    {
                        'filename',
                        cond = buffer_not_empty,
                    },
                    'diagnostics',
                },

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
