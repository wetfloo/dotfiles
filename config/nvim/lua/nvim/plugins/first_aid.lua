return {
    'first_aid',
    dir = '$HOME/projects/first_aid',
    enabled = true,
    dev = true,
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            "vhyrro/luarocks.nvim",
            priority = 1000,
            config = true,
            opts = {
                rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
            }
        },
        {
            "rest-nvim/rest.nvim",
            ft = "http",
            dependencies = { "luarocks.nvim" },
            config = function()
                require("rest-nvim").setup()
            end,
        }
    },
    config = function()
        P = function(val)
            print(vim.inspect(val))
            return val
        end

        RELOAD = function(...)
            return require('plenary.reload').reload_module(...)
        end

        R = function(name)
            RELOAD(name)
            return require(name)
        end

        require('first_aid').setup({ host = 'http://10.0.0.96:11434' })
        vim.keymap.set('n', '<leader>rr',
            function()
                vim.cmd('Lazy reload first_aid')
            end
        )
        vim.keymap.set('n', '<leader>rt',
            function()
                vim.cmd('up')
                vim.cmd('PlenaryBustedFile %')
            end)
    end,
}
