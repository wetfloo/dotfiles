local utils = require("utils")

return {
    "tpope/vim-fugitive",
    event = {
        "VeryLazy",
    },
    config = function()
        vim.keymap.set("n", "<leader>kb", function()
            utils.close_win_with_ft_or("fugitiveblame", false, function()
                vim.cmd("G blame")
            end)
        end, { desc = "Toggle git blame side window (git)" })
        vim.keymap.set("n", "<leader>kg", function()
            utils.close_win_with_ft_or("fugitive", false, function()
                vim.cmd("G")
            end)
        end, { desc = "Toggle git window (git)" })
    end,
}
