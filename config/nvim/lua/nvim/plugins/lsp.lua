--- Attemps to load a module,
--- passing it to |fn| when successful,
--- and doing nothing when failing
--- @param mod string Module name
--- @param fn function Must accept a module
local function maybe_load(mod, fn)
    local status, lib = pcall(require, mod)

    if status then
        fn(lib)
    end
end

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
    lsp_map(keymaps.diagnostic_prev, vim.diagnostic.goto_prev)
    lsp_map(keymaps.diagnostic_next, vim.diagnostic.goto_next)

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
    enabled = true,
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
            "hrsh7th/nvim-cmp",
            dependencies = {
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
                "hrsh7th/cmp-nvim-lsp",
                "rafamadriz/friendly-snippets",
            },
        },
    },
    config = function()
        local lspconfig = require("lspconfig")

        -- LSPs that need to be installed manually.
        local servers_manual = {
            clangd = {},
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
                        features = { "all" },
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
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        local function setup_opts(opts)
            return {
                capabilities = capabilities,
                settings = opts,
                filetypes = (opts or {}).filetypes,
                on_attach = on_attach,
            }
        end

        require("neodev").setup({})

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

        vim.diagnostic.config({
            severity_sort = true,
        })

        local cmp = require("cmp")
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()
        luasnip.config.setup({})

        cmp.setup(
            ---@diagnostic disable-next-line: missing-fields
            {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete({}),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                },
            }
        )
    end,
}
