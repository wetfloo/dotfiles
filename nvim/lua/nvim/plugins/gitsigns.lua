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

                        if desc ~= nil then
                            desc = desc .. ' (git)'
                        end

                        vim.keymap.set(mode, '<leader>' .. keys, func, { buffer = bufnr, desc = desc })
                    end

                    local gs = package.loaded.gitsigns

                    -- Navigation
                    map('kp', gs.prev_hunk, 'Go to previous hunk')
                    map('kn', gs.next_hunk, 'Go to next hunk')

                    -- Actions
                    map('ks', gs.stage_hunk, 'Stage hunk', 'n')
                    map('kr', gs.reset_hunk, 'Reset hunk', 'n')
                    -- It's important to keep these here to override all-mode stage and reset mappings above.
                    map('ks', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Stage hunk', 'x')
                    map('kr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Reset hunk', 'x')
                    map('kS', gs.stage_buffer, 'Stage buffer')
                    map('ku', gs.undo_stage_hunk, 'Undo staging hunk')
                    map('kR', gs.reset_buffer, 'Reset buffer')
                    map('kp', gs.preview_hunk, 'Preview hunk')
                    map('kb', function() gs.blame_line { full = true } end, 'Blame line')
                    map('kB', gs.toggle_current_line_blame, 'Toggle current line blame')
                    map('kc', gs.diffthis, 'Diff this')
                    map('kC', function() gs.diffthis('~') end, 'Diff this to one commit ago')
                    map('kd', gs.toggle_deleted, 'Toggle deleted')
                end,
            }
        )
    end,
}
