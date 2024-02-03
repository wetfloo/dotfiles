--- Attemps to load a module,
--- passing it to |fn| when successful,
--- and doing nothing when failing
--- @param mod string Module name
--- @param fn function Must accept a module
local function maybe_load(mod, fn)
    local status, lib = pcall(require, mod)

    if (status) then
        fn(lib)
    end
end

local function on_attach(_, bufnr, allow_without_lsp)
    local function lsp_desc(desc)
        return desc .. ' (LSP)'
    end

    local function lsp_map(keys, func, desc, mode_override)
        if desc then
            desc = lsp_desc(desc)
        end

        local mode
        if mode_override ~= nil then
            mode = mode_override
        else
            mode = 'n'
        end
        vim.keymap.set(
            mode,
            keys,
            -- Before allowing the bind,
            -- we need to check to see if the LSP is actually
            -- available in the current buffer
            function()
                local function any_client_attached()
                    local c = 0
                    for _ in pairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
                        c = c + 1
                    end

                    return c > 0
                end

                if allow_without_lsp == nil or allow_without_lsp or any_client_attached() then
                    func()
                end
            end,
            {
                buffer = bufnr,
                desc = desc,
            }
        )
    end

    local custom_pickers = require('nvim.plugins.utils.telescope_pickers')

    lsp_map('<leader>c', vim.lsp.buf.rename, 'Rename')
    lsp_map('<A-CR>', vim.lsp.buf.code_action, 'Code action')

    lsp_map('<leader>gg', vim.lsp.buf.definition, 'Go to definition')
    lsp_map('<leader>gu', require('telescope.builtin').lsp_references, 'Go to usages')
    lsp_map('<leader>gi', require('telescope.builtin').lsp_implementations,
        'Go to implementation')
    lsp_map('<leader>gd', vim.lsp.buf.type_definition, 'Go to definition')

    lsp_map(
        '<leader>fS',
        function()
            custom_pickers.pretty_document_symbols()
        end,
        'Find symbol in the current document'
    )
    lsp_map(
        '<leader>fs',
        function()
            custom_pickers.pretty_workspace_symbols()
        end,
        'Go to symbol'
    )

    lsp_map('K', vim.lsp.buf.hover, 'Hover Documentation', true)
    lsp_map('<leader>K', vim.lsp.buf.signature_help, 'Signature Documentation', true)

    lsp_map('<leader>ee', vim.diagnostic.open_float, 'Hover error')
    lsp_map('<leader>ep', vim.diagnostic.goto_prev, 'Show previous diagnostic')
    lsp_map('<leader>en', vim.diagnostic.goto_next, 'Show next diagnostic')

    lsp_map('<leader>gG', vim.lsp.buf.declaration, 'Go to declaration')
    lsp_map('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add workspace directory', true)
    lsp_map('<leader>wd', vim.lsp.buf.remove_workspace_folder, 'Remove workspace directory', true)
    lsp_map(
        '<leader>wl',
        function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        'Workspace directories list',
        true
    )

    local reformat_desc = lsp_desc('Format current buffer')
    vim.api.nvim_buf_create_user_command(
        bufnr,
        'Format',
        function(_)
            vim.lsp.buf.format()
        end,
        { desc = reformat_desc }
    )
    vim.keymap.set(
        'n',
        '<leader>sf',
        ':Format<CR>',
        {
            silent = true,
            desc = reformat_desc,
            buffer = bufnr,
        }
    )
end

return {
    'neovim/nvim-lspconfig',
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
        'folke/neodev.nvim',
        {
            'williamboman/mason.nvim',
            config = true, -- Uses the default implementation
            dependencies = 'williamboman/mason-lspconfig.nvim',
        },
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                'L3MON4D3/LuaSnip',
                'saadparwaiz1/cmp_luasnip',
                'hrsh7th/cmp-nvim-lsp',
                'rafamadriz/friendly-snippets',
            },
        },
    },
    config = function()
        local lspconfig = require('lspconfig')

        -- LSPs that need to be installed manually.
        local servers_manual = {
            gopls = {},
            rust_analyzer = {
                ["rust-analyzer"] = {
                    checkOnSave = {
                        command = 'clippy',
                    },
                }
            },
        }

        -- LSPs won't be auto-installed, but will be installed and configured by Mason.
        local servers_mason_manual = {
            denols = {
                root_dir = lspconfig.util.root_pattern(
                    'deno.json',
                    'deno.jsonc',
                    'lock.json'
                )
            },
        }

        -- LSPs that will be auto-installed by Mason.
        local servers_mason_auto = {
            lua_ls = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
        }

        local servers_auto = vim.tbl_deep_extend("keep", servers_mason_manual, servers_mason_auto)

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        local function setup_opts(opts)
            return {
                capabilities = capabilities,
                settings = opts,
                filetypes = (opts or {}).filetypes,
                on_attach = on_attach,
            }
        end

        maybe_load(
            'neodev',
            function(lib)
                lib.setup({})
            end
        )

        require('mason-lspconfig').setup(
            {
                ensure_installed = vim.tbl_keys(servers_mason_auto),
            }
        )
        require('mason-lspconfig').setup_handlers(
            {
                function(server_name)
                    lspconfig[server_name].setup(
                        setup_opts(servers_auto[server_name])
                    )
                end,
            }
        )

        for name, opts in pairs(servers_manual) do
            lspconfig[name].setup(setup_opts(opts))
        end

        local cmp = require('cmp')
        local luasnip = require('luasnip')
        require('luasnip.loaders.from_vscode').lazy_load()
        luasnip.config.setup({})

        cmp.setup(
        ---@diagnostic disable-next-line: missing-fields
            {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete {},
                    ['<CR>'] = cmp.mapping.confirm(
                        {
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = true,
                        }
                    ),
                    ['<Tab>'] = cmp.mapping(
                        function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            elseif luasnip.expand_or_locally_jumpable() then
                                luasnip.expand_or_jump()
                            else
                                fallback()
                            end
                        end,
                        { 'i', 's' }
                    ),
                    ['<S-Tab>'] = cmp.mapping(
                        function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            elseif luasnip.locally_jumpable(-1) then
                                luasnip.jump(-1)
                            else
                                fallback()
                            end
                        end,
                        { 'i', 's' }
                    ),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
            }
        )
    end,
}
