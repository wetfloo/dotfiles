return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    enabled = false, -- TODO: re-enable when it stops breaking LSP-related actions
    config = function()
        local status, lmu = pcall(require, "langmapper.utils")
        if status then
            local view = require("which-key.view")
            local execute = view.execute

            -- wrap `execute()` and translate sequence back
            ---@diagnostic disable-next-line: duplicate-set-field
            view.execute = function(prefix_i, mode, buf)
                -- Translate back to English characters
                prefix_i = lmu.translate_keycode(prefix_i, "default", "ru")
                execute(prefix_i, mode, buf)
            end

            -- If you want to see translated operators, text objects and motions in
            -- which-key prompt
            -- local presets = require('which-key.plugins.presets')
            -- presets.operators = lmu.trans_dict(presets.operators)
            -- presets.objects = lmu.trans_dict(presets.objects)
            -- presets.motions = lmu.trans_dict(presets.motions)
            -- etc
        end

        require("which-key").setup()
    end,
}
