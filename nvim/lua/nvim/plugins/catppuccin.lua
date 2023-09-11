return {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000, -- Needs to be loaded before anything else happens.
    config = function()
        require('catppuccin').setup(
           {
               transparent_background = true,
               flavour = 'mocha',
               integrations = {
                -- cmp = true,
                -- telescope = true,
                   neotree = true,
                -- which_key = true,
                -- treesitter = true,
                -- harpoon = true,
                -- mason = true,
               },
           }
        )

        -- Set the theme after setting it up.
        vim.cmd.colorscheme 'catppuccin'
    end
}
