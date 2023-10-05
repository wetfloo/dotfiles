return {
    'neovim/nvim-lspconfig',
    dependencies = {
        {
            'williamboman/mason.nvim',
            config = true, -- Uses the defeault implementation
        },
        'williamboman/mason-lspconfig.nvim',

        'folke/neodev.nvim',

        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                'L3MON4D3/LuaSnip',
                'saadparwaiz1/cmp_luasnip',
                'hrsh7th/cmp-nvim-lsp',
                'rafamadriz/friendly-snippets',
            },
        },
        {
            'lewis6991/gitsigns.nvim',
            opts = {},
        },
    },
    config = function()
        local servers = {
            lua_ls = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
        }

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        require('neodev').setup({})

        require('mason-lspconfig').setup(
            {
                ensure_installed = vim.tbl_keys(servers),
            }
        )
        require('mason-lspconfig').setup_handlers(
            {
                function(server_name)
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                        on_attach = function(_, bufnr)
                            local function lsp_desc(desc)
                                return desc .. '(LSP)'
                            end

                            local function lsp_nmap(keys, func, desc)
                                if desc then
                                    desc = lsp_desc(desc)
                                end

                                vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                            end

                            lsp_nmap('<leader>c', vim.lsp.buf.rename, 'Rename')
                            lsp_nmap('<A-CR>', vim.lsp.buf.code_action, 'Code action')

                            lsp_nmap('<leader>gg', vim.lsp.buf.definition, 'Go to definition')
                            lsp_nmap('<leader>gu', require('telescope.builtin').lsp_references, 'Go to usages')
                            lsp_nmap('<leader>gi', require('telescope.builtin').lsp_implementations,
                                'Go to implementation')
                            lsp_nmap('<leader>gd', vim.lsp.buf.type_definition, 'Go to definition')
                            lsp_nmap('<leader>fS', require('telescope.builtin').lsp_document_symbols, 'Find symbol')
                            lsp_nmap('<leader>fs', require('telescope.builtin').lsp_dynamic_workspace_symbols,
                                'Go to symbol')

                            lsp_nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                            lsp_nmap('<leader>K', vim.lsp.buf.signature_help, 'Signature Documentation')
                            lsp_nmap('<leader>e', vim.diagnostic.open_float, 'Hover error')

                            lsp_nmap('<leader>gG', vim.lsp.buf.declaration, 'Go to declaration')
                            lsp_nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add workspace directory')
                            lsp_nmap('<leader>wd', vim.lsp.buf.remove_workspace_folder, 'Remove workspace directory')
                            lsp_nmap('<leader>wl', function()
                                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                            end, 'Workspace directories list')

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
                        end,
                    }
                end
            }
        )

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
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
            }
        )
    end,
}
