-- TODO: this only allows lsp to be disabled for this instance on startup with no other way
-- to toggle it in runtime
local function get_lsp_status()
    local status = vim.g.lsp_status
    if status == false or status == 0 then
        return false
    end
    return true
end

-- local function toggle_lsp_status()
--     vim.g.lsp_status = not get_lsp_status()
-- end

-- vim.keymap.set("n", "<leader>l", toggle_lsp_status, {
--     noremap = true,
--     silent = true,
-- })

local function on_attach(_, bufnr)
    local function lsp_desc(desc)
        return desc .. " (LSP)"
    end

    local function lsp_map(keymap, action)
        keymap:map(action, { buffer = bufnr, desc = lsp_desc(keymap.desc) })
    end

    local keymaps = require("nvim.keymap").lsp
    local telescope_builtin = require("telescope.builtin")

    lsp_map(keymaps.rename, vim.lsp.buf.rename)
    lsp_map(keymaps.code_action, vim.lsp.buf.code_action)
    lsp_map(keymaps.goto_definition, vim.lsp.buf.definition)
    lsp_map(keymaps.goto_declaration, vim.lsp.buf.declaration)
    lsp_map(keymaps.goto_usages, telescope_builtin.lsp_references)
    lsp_map(keymaps.goto_implementation, telescope_builtin.lsp_implementations)
    lsp_map(keymaps.find_symbol_current_buf, telescope_builtin.lsp_document_symbols)
    lsp_map(keymaps.find_dynamic_symbol, telescope_builtin.lsp_dynamic_workspace_symbols)
    lsp_map(keymaps.find_symbol, telescope_builtin.lsp_workspace_symbols)

    lsp_map(keymaps.hover_documentation, vim.lsp.buf.hover)
    lsp_map(keymaps.signature_documentation, vim.lsp.buf.signature_help)

    lsp_map(keymaps.diagnostic_hover, vim.diagnostic.open_float)
    lsp_map(keymaps.diagnostic_prev, function()
        vim.diagnostic.jump({
            count = -1,
            float = true,
        })
    end)
    lsp_map(keymaps.diagnostic_next, function()
        vim.diagnostic.jump({
            count = 1,
            float = true,
        })
    end)

    lsp_map(keymaps.workspace_dir_add, vim.lsp.buf.add_workspace_folder)
    lsp_map(keymaps.workspace_dir_remove, vim.lsp.buf.remove_workspace_folder)
    lsp_map(keymaps.workspace_dir_list, function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end)

    local reformat_desc = lsp_desc("Format current buffer")
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = reformat_desc })
    keymaps.format:map(":Format<CR>", { silent = true, buffer = bufnr, desc = reformat_desc })
end

return {
    "neovim/nvim-lspconfig",
    -- TODO: this only allows lsp to be disabled for this instance on startup with no other way
    -- to toggle it in runtime
    enabled = get_lsp_status(),
    event = {
        "BufReadPost",
        "BufNewFile",
    },
    cmd = {
        "LspInfo",
        "LspInstall",
        "LspUninstall",
    },
    dependencies = {
        "folke/neodev.nvim",
        "nvim-lua/plenary.nvim",
        {
            "williamboman/mason.nvim",
            config = true, -- Uses the default implementation
            dependencies = {
                "williamboman/mason-lspconfig.nvim",
                {
                    "jay-babu/mason-null-ls.nvim",
                    event = { "BufReadPre", "BufNewFile" },
                    dependencies = {
                        "nvimtools/none-ls.nvim",
                        dependencies = "nvim-lua/plenary.nvim",
                        config = function()
                            local null_ls = require("null-ls")

                            null_ls.setup({
                                sources = {
                                    null_ls.builtins.formatting.black,
                                    null_ls.builtins.formatting.stylua,
                                    -- null_ls.builtins.formatting.beautysh,
                                },
                            })
                        end,
                    },
                },
            },
        },
        {
            "saghen/blink.cmp",
            -- optional: provides snippets for the snippet source
            dependencies = { "rafamadriz/friendly-snippets" },

            -- use a release tag to download pre-built binaries
            version = "1.*",
            -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
            -- build = 'cargo build --release',
            -- If you use nix, you can build from source using latest nightly rust with:
            -- build = 'nix run .#build-plugin',

            ---@module 'blink.cmp'
            ---@type blink.cmp.Config
            opts = {
                -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
                -- 'super-tab' for mappings similar to vscode (tab to accept)
                -- 'enter' for enter to accept
                -- 'none' for no mappings
                --
                -- All presets have the following mappings:
                -- C-space: Open menu or open docs if already open
                -- C-n/C-p or Up/Down: Select next/previous item
                -- C-e: Hide menu
                -- C-k: Toggle signature help (if signature.enabled = true)
                --
                -- See :h blink-cmp-config-keymap for defining your own keymap
                keymap = { preset = "enter" },

                appearance = {
                    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                    -- Adjusts spacing to ensure icons are aligned
                    nerd_font_variant = "mono",
                },

                -- (Default) Only show the documentation popup when manually triggered
                completion = { documentation = { auto_show = false } },

                -- Default list of enabled providers defined so that you can extend it
                -- elsewhere in your config, without redefining it, due to `opts_extend`
                sources = {
                    default = { "lsp", "path", "snippets", "buffer" },
                },

                -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
                -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
                -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
                --
                -- See the fuzzy documentation for more information
                fuzzy = { implementation = "prefer_rust_with_warning" },
            },
            opts_extend = { "sources.default" },
        },
    },
    config = function()
        local lspconfig = require("lspconfig")

        -- LSPs that need to be installed manually.
        local servers_manual = {
            gopls = {},
            rust_analyzer = {
                ["rust-analyzer"] = {
                    checkOnSave = {
                        command = "clippy",
                    },
                    cargo = {
                        -- This should, in theory, fix analyzer complaining
                        -- about code with #[cfg(not(test))] attribute.
                        -- For some reason it really doesn't...
                        -- features = { "all" },
                    },
                },
            },
        }

        -- LSPs won't be auto-installed, but will be installed and configured by Mason.
        local servers_mason_manual = {
            denols = {
                root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "lock.json"),
            },
            lua_ls = {
                Lua = {
                    workspace = {
                        checkThirdParty = false,
                        -- Fixes plenary not showing up in custom nvim plugins
                        library = vim.api.nvim_get_runtime_file("lua", true),
                    },
                    telemetry = { enable = false },
                },
            },
            ltex = {
                language = "ru-RU",
            },
        }

        -- LSPs that will be auto-installed by Mason.
        local servers_mason_auto = {}

        local servers_auto = vim.tbl_deep_extend("keep", servers_mason_manual, servers_mason_auto)

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

        local function setup_opts(opts)
            return {
                capabilities = capabilities,
                settings = opts,
                filetypes = (opts or {}).filetypes,
                on_attach = on_attach,
            }
        end

        ---@diagnostic disable-next-line: missing-fields
        require("neodev").setup({})

        ---@diagnostic disable-next-line: missing-fields
        require("mason-lspconfig").setup({
            ensure_installed = vim.tbl_keys(servers_mason_auto),
        })
        require("mason-lspconfig").setup_handlers({
            function(server_name)
                lspconfig[server_name].setup(setup_opts(servers_auto[server_name]))
            end,
        })

        for name, opts in pairs(servers_manual) do
            lspconfig[name].setup(setup_opts(opts))
        end
    end,
}
