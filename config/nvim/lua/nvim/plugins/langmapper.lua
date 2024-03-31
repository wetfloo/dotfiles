return {
    'Wansmer/langmapper.nvim',
    lazy = false,
    priority = 1,
    config = function()
        local function escape(str)
            -- You need to escape these characters to work correctly
            local escape_chars = [[;,."|\]]
            return vim.fn.escape(str, escape_chars)
        end

        -- Recommended to use lua template string
        local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
        local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
        local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
        local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

        local os_keys = {
            ["Linux"] = {
                en = en .. escape([[/@#$%^&]]),
                ru = ru .. escape([[."№;%:?]]),
                en_shift = en_shift .. escape([[?]]),
                ru_shift = ru_shift .. escape([[,]]),
            },
            ["Darwin"] = {
                en = en,
                ru = ru,
                en_shift = en_shift,
                ru_shift = ru_shift,
            }
        }
        local current_os_keys = os_keys[vim.loop.os_uname().sysname]

        vim.opt.langmap = vim.fn.join({
            -- | `to` should be first     | `from` should be second
            escape(current_os_keys.ru_shift) .. ';' .. escape(current_os_keys.en_shift),
            escape(current_os_keys.ru) .. ';' .. escape(current_os_keys.en),
        }, ',')

        require('langmapper').setup(
            {
                hack_keymap = true,
                disable_hack_modes = { 'i' },
                automapping_modes = { 'n', 'v', 'x', 's' },
                os = {
                    -- The result of `vim.loop.os_uname().sysname`.
                    Linux = {
                        ---Function for getting current keyboard layout on your OS
                        ---Should return string with id of layout
                        ---@return string | nil
                        get_current_layout_id = function()
                            local cmd = 'im-select'
                            if not vim.fn.executable(cmd) then
                                return nil
                            end

                            local output = vim.split(vim.trim(vim.fn.system(cmd)), '\n')
                            return output[#output]
                        end,
                    },
                    Darwin = {
                        get_current_layout_id = function()
                            local cmd = 'im-select'
                            if not vim.fn.executable(cmd) then
                                return nil
                            end

                            local output = vim.split(vim.trim(vim.fn.system(cmd)), '\n')
                            return output[#output]
                        end,
                    },
                },
            }
        )
        require('langmapper').automapping({ global = true, buffer = true })
    end,
}
