return {
    'ggandor/leap.nvim',
    dependencies = { 'Wansmer/langmapper.nvim' },
    config = function()
        require('leap').add_default_mappings()
        -- https://github.com/Wansmer/langmapper.nvim/discussions/11#discussion-5102704
        require("leap.util")["get-input"] = function()
            local ok, ch = pcall(vim.fn.getcharstr)
            if ok and ch ~= vim.api.nvim_replace_termcodes("<esc>", true, false, true) then
                return require("langmapper.utils").translate_keycode(ch, "default", "ru")
            end
        end
    end,
}
