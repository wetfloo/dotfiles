return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    dependencies = { 'Wansmer/langmapper.nvim' },
    config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 1000

        local lmu = require('langmapper.utils')
        local view = require('which-key.view')
        local execute = view.execute

        -- wrap `execute()` and translate sequence back
        ---@diagnostic disable-next-line: duplicate-set-field
        view.execute = function(prefix_i, mode, buf)
            -- Translate back to English characters
            prefix_i = lmu.translate_keycode(prefix_i, 'default', 'ru')
            execute(prefix_i, mode, buf)
        end

        -- If you want to see translated operators, text objects and motions in
        -- which-key prompt
        -- local presets = require('which-key.plugins.presets')
        -- presets.operators = lmu.trans_dict(presets.operators)
        -- presets.objects = lmu.trans_dict(presets.objects)
        -- presets.motions = lmu.trans_dict(presets.motions)
        -- etc


        require("which-key").setup()
    end
}
