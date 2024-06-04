return {
    "David-Kunz/gen.nvim",
    config = function()
        local gen = require("gen")
        gen.setup({
            model = "nous-hermes2:10.7b-solar-q4_K_M",
            host = "10.0.0.96",
            port = "11434",
            display_mode = "split",
        })

        -- sending commands via vim.cmd is bugged
        -- https://github.com/David-Kunz/gen.nvim/issues/16
        vim.keymap.set({ "n", "x" }, "<leader>?", ":Gen<CR>", { desc = "AI help", silent = true })

        gen.prompts["Elaborate_Text"] = {
            prompt = "Elaborate the following text:\n$text",
            replace = false,
        }
        gen.prompts["Fix_Code"] = {
            prompt = "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
            replace = true,
            extract = "```$filetype\n(.-)```",
        }
    end,
}
