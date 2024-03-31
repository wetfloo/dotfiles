return {
    'Wansmer/langmapper.nvim',
    enabled = true,
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
                en = [[]],
                ru = [[]],
                en_shift = [[]],
                ru_shift = [[]],
            },
            ["Darwin"] = {
                en = [[]],
                ru = [[]],
                en_shift = [[]],
                ru_shift = [[]],
            }
        }

        local os = vim.loop.os_uname().sysname
        local current_os_keys = os_keys[os]
        vim.opt.langmap = vim.fn.join(
            {
                escape(ru .. current_os_keys.ru) .. ';' .. escape(en .. current_os_keys.en),
                escape(ru_shift .. current_os_keys.ru_shift) .. ';' .. escape(en_shift .. current_os_keys.en_shift),
            },
            ','
        )

        local langmapper = require('langmapper')
        langmapper.setup(
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
                            local cmds = { 'setxkbmap', 'awk' }
                            local executable = 1
                            for _, cmd in ipairs(cmds) do
                                executable = executable and vim.fn.executable(cmd)
                            end
                            if executable then
                                local output = vim.split(
                                    vim.trim(
                                        vim.fn.system([[setxkbmap -query 2>/dev/null | awk '$1 ~ /layout/ {print $2}']])
                                    ), '\n')
                                return output[#output]
                            end
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
        require('langmapper').hack_get_keymap()
    end,
}
