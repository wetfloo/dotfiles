return {
    'lewis6991/gitsigns.nvim',
    config = function()
        require('gitsigns').setup(
            {
                on_attach = function(bufnr)
                    local function map(keys, func, desc, mode_override)
                        local mode
                        if mode_override ~= nil then
                            mode = mode_override
                        else
                            mode = ''
                        end
                        vim.keymap.set(mode, '<leader>' .. keys, func, { buffer = bufnr, desc = desc })
                    end

                    local gs = package.loaded.gitsigns

                    -- Navigation
                    map('kp', gs.prev_hunk)
                    map('kn', gs.next_hunk)

                    -- Actions
                    map('ks', gs.stage_hunk)
                    map('kr', gs.reset_hunk)
                    -- It's important to keep these here to override all-mode stage and reset mappings above.
                    map('ks', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'x')
                    map('kr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'x')
                    map('kS', gs.stage_buffer)
                    map('ku', gs.undo_stage_hunk)
                    map('kR', gs.reset_buffer)
                    map('kp', gs.preview_hunk)
                    map('kb', function() gs.blame_line { full = true } end)
                    map('kB', gs.toggle_current_line_blame)
                    map('kc', gs.diffthis)
                    map('kC', function() gs.diffthis('~') end)
                    map('kd', gs.toggle_deleted)
                end,
            }
        )
    end,
}
