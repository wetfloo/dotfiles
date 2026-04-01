-- Load initials basic editor stuff that doesn't require any plugins to run

require("common.editor")

local vscode = vim.g.vscode

if vscode then
	require("vscode.editor")
else
	require("nvim.editor")

	require("nvim.keymap").noopify()
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
})

if not vscode then
	local status, langmapper = pcall(require, "langmapper")
	if status then
		langmapper.automapping({ global = true, buffer = true })
	end
end
