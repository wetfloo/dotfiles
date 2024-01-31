return {
    'stevearc/oil.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require('oil').setup(
            {
                use_default_keymaps = false,
                keymaps = {
                    ["<leader>t?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    ["<leader>tv"] = "actions.select_vsplit",
                    ["<leader>th"] = "actions.select_split",
                    ["<leader>tn"] = "actions.select_tab",
                    ["<leader>tp"] = "actions.preview",
                    ["<leader>tt"] = "actions.close",
                    ["<leader>tr"] = "actions.refresh",
                    ["-"] = "actions.parent",
                    ["_"] = "actions.open_cwd",
                    ["`"] = "actions.cd",
                    ["~"] = "actions.tcd",
                    ["<leader>ts"] = "actions.change_sort",
                    ["<leader>tx"] = "actions.open_external",
                    ["<leader>t."] = "actions.toggle_hidden",
                },
            }
        )

        vim.keymap.set('n', '<leader>tt', ':Oil<CR>', { desc = 'Open file explorer', silent = true })
    end,
}
