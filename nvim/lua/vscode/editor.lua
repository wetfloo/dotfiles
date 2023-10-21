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

vscode_map('', '<leader>dv', 'workbench.action.splitEditorRight', { desc = 'Divide (split) vertically' })
vscode_map('', '<leader>dh', 'workbench.action.splitEditorDown', { desc = 'Divide (split) horizontally' })
vscode_map({ 'n', 'x' }, '<C-k>', 'workbench.action.focusAboveGroup', { desc = 'To split above' })
vscode_map({ 'n', 'x' }, '<C-j>', 'workbench.action.focusBelowGroup', { desc = 'To split below' })
vscode_map({ 'n', 'x' }, '<C-h>', 'workbench.action.focusLeftGroup', { desc = 'To split on the left' })
vscode_map({ 'n', 'x' }, '<C-l>', 'workbench.action.focusRightGroup', { desc = 'To split on the right' })

-- Move between tabs more easily

vscode_map('', '<A-.>', 'workbench.action.nextEditor')
vscode_map('', '<A-,>', 'workbench.action.previousEditor')
vscode_map('', '<A-d>', 'workbench.action.closeActiveEditor')
vscode_map('', '<leader>\'', 'notifications.clearAll')
vscode_map(
    '',
    '<leader>\\',
    {
        'workbench.action.closePanel',
        'workbench.action.closeSidebar',
    }
)

-- Find stuff

vscode_map('', '<leader>ff', 'workbench.action.quickOpen', { desc = 'Find Files' })
vscode_map('', '<leader>fg', 'workbench.action.findInFiles', { desc = 'Find with Grep' })
vscode_map('', '<leader>fs', 'workbench.action.showAllSymbols', { desc = 'Find Symbol' })

-- Debugging

vscode_map('', '<leader>oo', 'editor.debug.action.toggleBreakpoint')
vscode_map('', '<leader>oD', 'workbench.debug.viewlet.action.removeAllBreakpoints')
vscode_map('', '<leader>om', 'workbench.debug.viewlet.action.toggleBreakpointsActivatedAction')

-- LSP related

vscode_map('', '<leader>c', 'editor.action.rename')
vscode_map('', '<leader>gg', 'editor.action.revealDefinition')
vscode_map('', '<leader>gu', 'editor.action.goToReferences')
vscode_map('', '<leader>gi', 'editor.action.goToImplementation')
vscode_map('', '<leader>gt', 'editor.action.goToTypeDefinition')

-- Version control

vscode_map('', '<leader>ks', 'git.stageAll')
vscode_map('', '<leader>ku', 'git.unstageAll')
vscode_map('', '<leader>kk', 'git.commit')
vscode_map('', '<leader>kc', 'git.openChange')
vscode_map('', '<leader>kp', 'git.push')
vscode_map('', '<leader>kf', 'git.fetch')
vscode_map('', '<leader>kF', 'git.fetchPrune')
vscode_map('', '<leader>ky', { 'git.fetch', 'git.pull' })
vscode_map('', '<leader>kA', 'git.commitAllAmend')
vscode_map('', '<leader>ka', 'git.commitAmend')
vscode_map('', '<leader>kD', 'git.cleanAll')
vscode_map('', '<leader>kss', 'git.stash')
vscode_map('', '<leader>ksp', 'git.stashPop')
