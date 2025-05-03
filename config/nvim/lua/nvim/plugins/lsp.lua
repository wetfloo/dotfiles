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

			-- use a release tag to download pre-built binaries
			version = "1.*",
			-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
			-- build = 'cargo build --release',
			-- If you use nix, you can build from source using latest nightly rust with:
			-- build = 'nix run .#build-plugin',

			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				-- See :h blink-cmp-config-keymap for defining your own keymap
				keymap = {
					["<C-k>"] = { "show_documentation", "hide_documentation", "fallback_to_mappings" },
					["<C-e>"] = { "show", "hide", "fallback" },
					["<CR>"] = { "accept", "fallback" },

					["<Tab>"] = { "snippet_forward", "fallback" },
					["<S-Tab>"] = { "snippet_backward", "fallback" },

					["<Up>"] = { "select_prev", "fallback" },
					["<Down>"] = { "select_next", "fallback" },
					["<C-p>"] = { "select_prev", "fallback_to_mappings" },
					["<C-n>"] = { "select_next", "fallback_to_mappings" },

					["<C-b>"] = { "scroll_documentation_up", "fallback" },
					["<C-f>"] = { "scroll_documentation_down", "fallback" },

					["<C-j>"] = { "show_signature", "hide_signature", "fallback" },
				},
				signature = { enabled = true },

				cmdline = {
					completion = {
						menu = { auto_show = true },
						list = {
							selection = {
								auto_insert = false,
								preselect = true,
							},
						},
						ghost_text = { enabled = true },
					},
				},

				completion = { documentation = { auto_show = true } },
			},
			opts_extend = { "sources.default" },
		},
	},
	config = function()
		-- Fix for blink highlights the source is selected.
		-- See https://www.reddit.com/r/neovim/comments/1hmuwaz/help_debugging_a_highlight_that_doesnt_go_away_in/
		vim.keymap.set({ "i", "s" }, "<Esc>", "<Esc>:lua vim.snippet.stop()<CR>", { remap = true, silent = true })

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
