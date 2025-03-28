local M = {}

local record_meta = {
    map = function(self, action, opts)
        local merged_opts = vim.tbl_deep_extend("keep", opts or {}, { desc = self.desc })
        vim.keymap.set(self.mode, self.keys, action, merged_opts)
    end,
}

M.lsp = {
    format = { mode = "n", keys = "<leader>sf", desc = "Format current buffer" },
    rename = { mode = "n", keys = "<leader>c", desc = "Rename" },
    code_action = { mode = "n", keys = "<A-CR>", desc = "Code action" },
    goto_definition = { mode = "n", keys = "<leader>gg", desc = "Go to definition" },
    goto_usages = { mode = "n", keys = "<leader>gu", desc = "Go to usages" },
    goto_implementation = { mode = "n", keys = "<leader>gi", desc = "Go to implementation" },
    goto_declaration = { mode = "n", keys = "<leader>gd", desc = "Go to declaration" },
    find_symbol_current_buf = { mode = "n", keys = "<leader>fd", desc = "Find symbol in the current document" },
    -- just using workspace symbols doesn't work with some lsps (pyright, gopls)
    find_dynamic_symbol = { mode = "n", keys = "<leader>fa", desc = "Find dynamic symbol" },
    find_symbol = { mode = "n", keys = "<leader>fs", desc = "Find symbol" },
    hover_documentation = { mode = "n", keys = "K", desc = "Hover Documentation" },
    signature_documentation = { mode = "n", keys = "<leader>K", desc = "Signature Documentation" },
    diagnostic_hover = { mode = "n", keys = "<C-c>", desc = "Hover error" },
    diagnostic_prev = { mode = "n", keys = "<A-[>", desc = "Show previous diagnostic" },
    diagnostic_next = { mode = "n", keys = "<A-]>", desc = "Show next diagnostic" },
    workspace_dir_add = { mode = "n", keys = "<leader>wa", desc = "Add workspace directory" },
    workspace_dir_remove = { mode = "n", keys = "<leader>wd", desc = "Remove workspace directory" },
    workspace_dir_list = { mode = "n", keys = "<leader>wl", desc = "Workspace directories list" },
}

M.ftplugin = {
    validate = { mode = { "n", "x" }, keys = "<leader>sv", desc = "Validate buffer/selection" },
}

for _, group in pairs(M) do
    for _, tbl in pairs(group) do
        setmetatable(tbl, { __index = record_meta })
    end
end

--- Disables all kinds of dependant keybinds.
M.noopify = function()
    for _, group in pairs(M) do
        if type(group) == "table" then
            for _, tbl in pairs(group) do
                vim.keymap.set(tbl.mode, tbl.keys, "<Nop>", { desc = tbl.desc .. "(disabled)" })
            end
        end
    end
end

return M
