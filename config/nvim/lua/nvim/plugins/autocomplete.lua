--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"saghen/blink.cmp",

	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',
	opts_extend = { "sources.default" },
}

---@module 'blink.cmp'
---@type blink.cmp.Config
M.opts = {
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
}

return M
