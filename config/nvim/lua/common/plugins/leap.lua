return {
    "ggandor/leap.nvim",
    dependencies = { "Wansmer/langmapper.nvim" },
    config = function()
        local leap = require("leap")
        leap.add_default_mappings()
        leap.setup({})

        local status, lmu = pcall(require, "langmapper.utils")
        if not status then
            return
        end

        -- https://github.com/Wansmer/langmapper.nvim/discussions/11#discussion-5102704
        require("leap.util")["get-input"] = function()
            local ok, ch = pcall(vim.fn.getcharstr)
            if ok and ch ~= vim.api.nvim_replace_termcodes("<esc>", true, false, true) then
                return lmu.translate_keycode(ch, "default", "ru")
            end
        end
    end,
}
