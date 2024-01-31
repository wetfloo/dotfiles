return {
    'David-Kunz/gen.nvim',
    config = function()
        local gen = require('gen')

        gen.model = 'llama2-uncensored'

        vim.keymap.set({ 'n', 'x' }, '<leader>?', function() vim.cmd('Gen') end, { desc = 'AI help', silent = true })

        gen.prompts['Elaborate_Text'] = {
            prompt = "Elaborate the following text:\n$text",
            replace = true
        }
        gen.prompts['Fix_Code'] = {
            prompt =
            "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
            replace = true,
            extract = "```$filetype\n(.-)```"
        }
    end,
}
