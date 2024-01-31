return {
    'kevinhwang91/nvim-ufo',
    dependencies = {
        'kevinhwang91/promise-async',
        'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        vim.o.foldcolumn = '0'
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

        -- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
        -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
        require('ufo').setup(
            {
                close_fold_kinds = {},
                ---@diagnostic disable-next-line: unused-local
                provider_selector = function(bufnr, filetype, buftype)
                    return { 'treesitter', 'indent' }
                end,
                -- https://github.com/kevinhwang91/nvim-ufo/tree/6f2ccdf2da390d62f8f9e15fc5ddbcbd312e1e66#customize-fold-text
                fold_virt_text_handler = function(virt_text, line_num, end_line_num, width, truncate)
                    local result = {}
                    local suffix = (' 󰘕 %d '):format(end_line_num - line_num)
                    local suffix_width = vim.fn.strdisplaywidth(suffix)
                    local target_width = width - suffix_width
                    local cur_width = 0
                    for _, chunk in ipairs(virt_text) do
                        local chunk_text = chunk[1]
                        local chunk_width = vim.fn.strdisplaywidth(chunk_text)
                        if target_width > cur_width + chunk_width then
                            table.insert(result, chunk)
                        else
                            chunk_text = truncate(chunk_text, target_width - cur_width)
                            local hl_group = chunk[2]
                            table.insert(result, { chunk_text, hl_group })
                            chunk_width = vim.fn.strdisplaywidth(chunk_text)
                            -- str width returned from truncate() may less than 2nd argument, need padding
                            if cur_width + chunk_width < target_width then
                                suffix = suffix .. (' '):rep(target_width - cur_width - chunk_width)
                            end
                            break
                        end
                        cur_width = cur_width + chunk_width
                    end
                    table.insert(result, { suffix, 'MoreMsg' })
                    return result
                end
            }
        )
    end,
}
