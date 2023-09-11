local vscode = require('vscode-neovim')

---@param mode string|table    Mode short-name, see |nvim_set_keymap()|.
---                            Can also be list of modes to create mapping on multiple modes.
---@param lhs string           Left-hand side |{lhs}| of the mapping.
---@param rhs string|function|table  Right-hand side |{rhs}| of the mapping, can be a Lua function.
---
---@param opts table|nil Table of |:map-arguments|.
---                      - Same as |nvim_set_keymap()| {opts}, except:
---                        - "replace_keycodes" defaults to `true` if "expr" is `true`.
---                        - "noremap": inverse of "remap" (see below).
---                      - Also accepts:
---                        - "buffer" number|boolean Creates buffer-local mapping, `0` or `true`
---                        for current buffer.
---                        - remap: (boolean) Make the mapping recursive. Inverses "noremap".
---                        Defaults to `false`.
local function vscode_map(mode, lhs, rhs, opts)
    -- Allow for multiple actions
    vim.keymap.set(
        mode,
        lhs,
        function()
            if type(rhs) == 'table' then
                for _, value in ipairs(rhs) do
                    vscode.notify(value)
                end
            else
                vscode.notify(rhs)
            end
        end,
        opts
    )
end

vscode_map('n', '<leader>sf', 'editor.action.formatDocument')
vscode_map('x', '<leader>sf', 'editor.action.formatSelection')

-- Making it more comfortable to work with mutliple splits

vscode_map({ 'n', 'x' }, '<leader>dv', 'workbench.action.splitEditorRight', { desc = '[D]ivide (split) vertically' })
vscode_map({ 'n', 'x' }, '<leader>dh', 'workbench.action.splitEditorDown', { desc = '[D]ivide (split) horizontally' })
vscode_map({ 'n', 'x' }, '<C-k>', 'workbench.action.focusAboveGroup', { desc = 'To split above' })
vscode_map({ 'n', 'x' }, '<C-j>', 'workbench.action.focusBelowGroup', { desc = 'To split below' })
vscode_map({ 'n', 'x' }, '<C-h>', 'workbench.action.focusLeftGroup', { desc = 'To split on the left' })
vscode_map({ 'n', 'x' }, '<C-l>', 'workbench.action.focusRightGroup', { desc = 'To split on the right' })

-- Move between tabs more easily

vscode_map({ 'n', 'x' }, '<A-l>', 'workbench.action.nextEditor')
vscode_map({ 'n', 'x' }, '<A-h>', 'workbench.action.previousEditor')
vscode_map({ 'n', 'x' }, '<A-d>', 'workbench.action.closeActiveEditor')
vscode_map({ 'n', 'x' }, '<leader>\'', 'notifications.clearAll')
vscode_map(
    { 'n', 'x' },
    '<leader>\\',
    {
        'workbench.action.closePanel',
        'workbench.action.closeSidebar',
    }
)

-- Find stuff

vscode_map({ 'n', 'x' }, '<leader>ff', 'workbench.action.quickOpen', { desc = '[F]ind [F]iles' })
vscode_map({ 'n', 'x' }, '<leader>fg', 'workbench.action.findInFiles', { desc = '[F]ind with [G]rep' })
vscode_map({ 'n', 'x' }, '<leader>fs', 'workbench.action.showAllSymbols', { desc = '[F]ind [S]ymbol' })

-- Debugging

vscode_map({ 'n', 'x' }, '<leader>oo', 'editor.debug.action.toggleBreakpoint')
vscode_map({ 'n', 'x' }, '<leader>oD', 'workbench.debug.viewlet.action.removeAllBreakpoints')
vscode_map({ 'n', 'x' }, '<leader>om', 'workbench.debug.viewlet.action.toggleBreakpointsActivatedAction')

-- LSP related

vscode_map({ 'n', 'x' }, '<leader>c', 'editor.action.rename')
vscode_map({ 'n', 'x' }, '<leader>gg', 'editor.action.revealDefinition')
vscode_map({ 'n', 'x' }, '<leader>gu', 'editor.action.goToReferences')
vscode_map({ 'n', 'x' }, '<leader>gi', 'editor.action.goToImplementation')
vscode_map({ 'n', 'x' }, '<leader>gt', 'editor.action.goToTypeDefinition')

-- Version control

vscode_map({ 'n', 'x' }, '<leader>ks', 'git.stageAll')
vscode_map({ 'n', 'x' }, '<leader>ku', 'git.unstageAll')
vscode_map({ 'n', 'x' }, '<leader>kk', 'git.commit')
vscode_map({ 'n', 'x' }, '<leader>kc', 'git.openChange')
vscode_map({ 'n', 'x' }, '<leader>kp', 'git.push')
vscode_map({ 'n', 'x' }, '<leader>kf', 'git.fetch')
vscode_map({ 'n', 'x' }, '<leader>kF', 'git.fetchPrune')
vscode_map({ 'n', 'x' }, '<leader>ky', { 'git.fetch', 'git.pull' })
vscode_map({ 'n', 'x' }, '<leader>kA', 'git.commitAllAmend')
vscode_map({ 'n', 'x' }, '<leader>ka', 'git.commitAmend')
vscode_map({ 'n', 'x' }, '<leader>kD', 'git.cleanAll')
vscode_map({ 'n', 'x' }, '<leader>kss', 'git.stash')
vscode_map({ 'n', 'x' }, '<leader>ksp', 'git.stashPop')
