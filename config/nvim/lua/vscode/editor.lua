local vscode = require("vscode-neovim")

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
	vim.keymap.set(mode, lhs, function()
		if type(rhs) == "table" then
			for _, value in ipairs(rhs) do
				vscode.notify(value)
			end
		else
			vscode.notify(rhs)
		end
	end, opts)
end

vscode_map("n", "<leader>sf", "editor.action.formatDocument")
vscode_map("x", "<leader>sf", "editor.action.formatSelection")

-- Making it more comfortable to work with mutliple splits
vscode_map("n", "<leader>dv", "workbench.action.splitEditorRight", { desc = "Divide (split) vertically" })
vscode_map("n", "<leader>dh", "workbench.action.splitEditorDown", { desc = "Divide (split) horizontally" })
vscode_map("n", "<C-k>", "workbench.action.focusAboveGroup", { desc = "To split above" })
vscode_map("n", "<C-j>", "workbench.action.focusBelowGroup", { desc = "To split below" })
vscode_map("n", "<C-h>", "workbench.action.focusLeftGroup", { desc = "To split on the left" })
vscode_map("n", "<C-l>", "workbench.action.focusRightGroup", { desc = "To split on the right" })

-- Move between tabs more easily
vscode_map("n", "<A-.>", "workbench.action.nextEditor")
vscode_map("n", "<A-,>", "workbench.action.previousEditor")
vscode_map("n", "<A-d>", "workbench.action.closeActiveEditor")
vscode_map("n", "<leader>'", "notifications.clearAll")
vscode_map("n", "<leader>\\", {
	"workbench.action.closePanel",
	"workbench.action.closeSidebar",
})

-- Find stuff
vscode_map("n", "<leader>ff", "workbench.action.quickOpen", { desc = "Find Files" })
vscode_map("n", "<leader>fg", "workbench.action.findInFiles", { desc = "Find with Grep" })
vscode_map("n", "<leader>fs", "workbench.action.showAllSymbols", { desc = "Find Symbol" })

-- Debugging
vscode_map("n", "<leader>oo", "editor.debug.action.toggleBreakpoint")
vscode_map("n", "<leader>oD", "workbench.debug.viewlet.action.removeAllBreakpoints")
vscode_map("n", "<leader>om", "workbench.debug.viewlet.action.toggleBreakpointsActivatedAction")

-- LSP related
vscode_map("n", "<leader>c", "editor.action.rename")
vscode_map("n", "<leader>gg", "editor.action.revealDefinition")
vscode_map("n", "<leader>gu", "editor.action.goToReferences")
vscode_map("n", "<leader>gi", "editor.action.goToImplementation")
vscode_map("n", "<leader>gt", "editor.action.goToTypeDefinition")

-- Version control
vscode_map("n", "<leader>ks", "git.stageAll")
vscode_map("n", "<leader>ku", "git.unstageAll")
vscode_map("n", "<leader>kk", "git.commit")
vscode_map("n", "<leader>kc", "git.openChange")
vscode_map("n", "<leader>kp", "git.push")
vscode_map("n", "<leader>kf", "git.fetch")
vscode_map("n", "<leader>kF", "git.fetchPrune")
vscode_map("n", "<leader>ky", { "git.fetch", "git.pull" })
vscode_map("n", "<leader>kA", "git.commitAllAmend")
vscode_map("n", "<leader>ka", "git.commitAmend")
vscode_map("n", "<leader>kD", "git.cleanAll")
vscode_map("n", "<leader>kss", "git.stash")
vscode_map("n", "<leader>ksp", "git.stashPop")
