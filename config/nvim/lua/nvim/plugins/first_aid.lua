return {
    'first_aid',
    dir = '$HOME/projects/first_aid',
    enabled = true,
    dev = true,
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
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
