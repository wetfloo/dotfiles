local utils = require("utils")

-- Avoid weird 8 space tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.o.termguicolors = true

-- Visual editor stuff: line wraps, scrolloff, relative line numbers
vim.o.wrap = true
vim.o.scrolloff = 5
vim.wo.number = true
vim.wo.relativenumber = true

vim.wo.signcolumn = "yes"

-- Disable netrw, since I'm using neotree
--
-- NOTICE: this prevents spell auto-downloads from working.
-- In order to fix this, comment the lines below, and disable
-- your current filepicker. (Oil, neotree, etc.).
-- You can re-enable downloading dictionaries.
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0

vim.o.cursorline = false
-- vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkon500"

vim.opt.updatetime = 500
vim.opt.inccommand = "nosplit"

vim.o.spell = true
vim.o.spelllang = "en_us,ru_ru"
vim.fn.mkdir(vim.fn.stdpath("data") .. "site/spell", "p")

vim.keymap.set("", "<C-c>", "<Esc>")
vim.keymap.set("", "<F1>", "<Nop>")
vim.keymap.set("!", "<F1>", "<Nop>")

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.keymap.set("n", "<leader>qq", function()
    -- Currently open windows
    utils.close_win_with_ft_or("qf", false, function()
        vim.cmd("copen")
    end)
end, { desc = "Toggle quickfix window" })

local function qfmove(mode, lhs, fn, opts)
    vim.keymap.set(mode, lhs, function()
        ---@diagnostic disable-next-line: param-type-mismatch
        local ok, _ = pcall(fn)
        if not ok then
            print("No more quickfix entries")
        end
    end, opts)
end

qfmove("n", "<leader>qp", function()
    vim.cmd("cprev")
end, { desc = "Previous quickfix entry" })
qfmove("n", "<leader>qn", function()
    vim.cmd("cnext")
end, { desc = "Next quickfix entry" })

-- Making it more comfortable to work with mutliple splits.
-- The rest of keybinds are provided by the tmux plugin.
vim.keymap.set("n", "<leader>dv", "<C-w>v", { desc = "Divide (split) vertically" })
vim.keymap.set("n", "<leader>dh", "<C-w>s", { desc = "Divide (split) horizontally" })
vim.keymap.set("n", "<leader>du", function()
    vim.cmd("on")
end, { desc = "Close all other windows (unsplit)" })

-- Move around buffers as if they're tabs
vim.keymap.set("n", "<A-,>", ":bprev<CR>", { desc = "Go to the previous buffer", silent = true })
vim.keymap.set("n", "<A-.>", ":bnext<CR>", { desc = "Go to the next buffer", silent = true })
vim.keymap.set("n", "<A-d>", ":Bdelete<CR>", { desc = "Delete the current buffer", silent = true })
vim.keymap.set("n", "<A-D>", ":Bdelete!<CR>", { desc = "Force delete the current buffer", silent = true })
vim.keymap.set("n", "<A-q>", "<C-w>q", { desc = "Close current window" })
vim.keymap.set("n", "<C-S>", function()
    vim.cmd("update")
end, { desc = "Save buffer changes" })

-- Remap for dealing with word wrap
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gkzz' : 'k'", { expr = true, silent = true })
-- vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gjzz' : 'j'", { expr = true, silent = true })
-- vim.keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gkzz' : 'k'", { expr = true, silent = true })
-- vim.keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gjzz' : 'j'", { expr = true, silent = true })

-- Move selected stuff around
vim.keymap.set("n", "<A-p>", ":mo -2<CR>==", { desc = "Move current line one line up", silent = true })
vim.keymap.set("n", "<A-n>", ":mo +1<CR>==", { desc = "Move current line one line down", silent = true })
vim.keymap.set("x", "<A-p>", ":'<,'> mo -2<CR>gv=gv", { desc = "Move selection one line up", silent = true })
vim.keymap.set("x", "<A-n>", ":'<,'> mo '>+<CR>gv=gv", { desc = "Move selection one line down", silent = true })

vim.keymap.set("x", "<C-a>", "<C-a>gv")
vim.keymap.set("x", "<C-x>", "<C-x>gv")

local function yank_file_local(keys, expand_str, obj_desc)
    vim.keymap.set("n", "<leader>n" .. keys, function()
        -- :help filename-modifiers
        local path = vim.fn.expand(expand_str)
        -- TODO: this is a temp solution until I find a way to
        -- perform yanking of arbitrary text into registers
        -- instead of settings those registers manually
        vim.fn.setreg('"', path)
        vim.fn.setreg("0", path)
    end, { desc = "Yank " .. obj_desc })
end

local function yank_file_plus(keys, expand_str, obj_desc)
    vim.keymap.set("n", "<leader>n" .. keys, function()
        -- :help filename-modifiers
        local path = vim.fn.expand(expand_str)
        -- TODO: this is a temp solution until I find a way to
        -- perform yanking of arbitrary text into registers
        -- instead of settings those registers manually
        vim.fn.setreg("*", path)
        vim.fn.setreg("+", path)
    end, { desc = "Yank " .. obj_desc .. "to system clipboard" })
end

local function yank_file(keys, expand_str, obj_desc)
    yank_file_local(string.lower(keys), expand_str, obj_desc)
    yank_file_plus(string.upper(keys), expand_str, obj_desc)
end

yank_file("p", "%:p:.", "file path")
yank_file("d", "%:h", "directory path")
yank_file("n", "%:t:r", "file name")

--- Centers the view after moving
local function move_and_center(mode, action, opts)
    local esc_action = vim.api.nvim_replace_termcodes(action, true, true, true)
    vim.keymap.set(mode, action, function()
        -- Setup
        local option = "scrolloff"
        local scrolloff = vim.api.nvim_get_option_value(option, {})
        vim.api.nvim_set_option_value(option, 99999, {})
        -- Without this cursor will stay at the same place
        vim.cmd("norm! M")

        -- Action
        vim.api.nvim_feedkeys(esc_action, "n", false)

        -- Teardown
        vim.api.nvim_set_option_value(option, scrolloff, {})
    end, opts)
end

local function move_and_center_old(mode, keys, opts)
    vim.keymap.set(mode, keys, keys .. "zz", opts)
end

move_and_center({ "n", "x" }, "<C-d>")
move_and_center({ "n", "x" }, "<C-u>")
move_and_center({ "n", "x" }, "<C-b>")
move_and_center({ "n", "x" }, "<C-f>")
move_and_center({ "n", "x" }, "gg")
move_and_center({ "n", "x" }, "G")

-- This didn't work with the new one
move_and_center_old({ "n", "x" }, "n")
move_and_center_old({ "n", "x" }, "N")

-- :help diagnostic-highlights
vim.diagnostic.config({
    virtual_text = {
        severity = vim.diagnostic.severity.ERROR,
    },
})

-- Define signs on the left for diagnostics.
local signs = require("nvim.prefs").diagnostic_signs
for type, icon in pairs(signs) do
    local highlight = "DiagnosticSign" .. type
    vim.fn.sign_define(highlight, { text = icon, texthl = highlight, numhl = "" })
end
