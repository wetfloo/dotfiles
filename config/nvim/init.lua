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
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

if not vscode then
    local status, langmapper = pcall(require, "langmapper")
    if status then
        langmapper.automapping({ global = true, buffer = true })
    end
end
