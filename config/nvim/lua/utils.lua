local function readonlify_table(table)
    setmetatable(table, {
        __index = table,
        __newindex = function() end,
    })
end

local M = {}

M.readonlify_table = readonlify_table

--- Example
---
--- M.function_name = function(params)
---     ...
--- end
---
--- Then, in the target module:
--- local module = require('utils')
--- module.function_name(params)

function M.leader_prefix(keys)
    return vim.g.mapleader .. keys
end

--- Finds all open windows that match the given {ft}
--- @param ft string
--- @return table
function M.find_open_wins_with_ft(ft)
    local wins = vim.api.nvim_list_wins()
    -- Their respective buffers
    local bufs = {}
    for _, win in ipairs(wins) do
        bufs[win] = vim.api.nvim_win_get_buf(win)
    end

    local result = {}
    for win, buf in pairs(bufs) do
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
        if filetype == ft then
            table.insert(result, win)
        end
    end

    return result
end

--- Close all windows with a given {ft}, or run provided {fn}, if available
--- @param ft string
--- @param force boolean
--- @param fn function|nil
function M.close_win_with_ft_or(ft, force, fn)
    local wins = M.find_open_wins_with_ft(ft)

    if #wins == 0 then
        if fn ~= nil then
            fn()
        end
    else
        for _, win in ipairs(wins) do
            vim.api.nvim_win_close(win, force)
        end
    end
end

--- @param path string
--- @return string
function M.module_name(path)
    local result, _ = path:gsub("%w+%.", "")
    return result
end

function M.env(path)
    local result, _ = path:gsub("%.%w+", "")
    return result
end

--- @param path string
--- @param prev table
--- @return table
function M.plugin_config(path, prev)
    local module_name = M.module_name(path)
    local env = M.env(path)
    local config = require(env .. ".plugins.config." .. module_name)

    return vim.tbl_deep_extend("keep", prev, config)
end

function M.dir_content(dir)
    -- Note 1: if dir contains a trailing "/" because the CWD was acquired
    -- by means other than getcwd() (e.g. Lua string matching/substitution),
    -- then remove the "/" preceding the "*" in the above line to avoid "//" issues
    --
    -- Note 2: use {trimempty=true} to ensure that vim.split() drops
    -- empty space preceding a separator instead of treating it as en entity to keep.
    return vim.split(vim.fn.glob(dir .. "/*"), "\n", { trimempty = true })
end

function M.dir_contains(dir, name)
    local full_name = dir .. "/" .. name
    local contents = M.dir_content(dir)

    for _, item in pairs(contents) do
        if string.find(item, full_name) then
            return true
        end
    end

    return false
end

-- All the credit goes to https://github.com/f-person/auto-dark-mode.nvim contributors for figuring this out
-- It works for theme selections on startup, but will do for now.
-- I really like lackluster.nvim and don't wanna switch, so this is my best bet to stay with it until light
-- mode is added there. Some work on it has been made here https://github.com/hocman2/lackluster.nvim/tree/light-variant,
-- buuut it seems to break lualine and other stuff
local is_dark_mode = {}

function is_dark_mode:init_system()
    if self.system ~= nil then
        return
    end

    if string.match(vim.loop.os_uname().release, "WSL") then
        self.system = "WSL"
    else
        self.system = vim.loop.os_uname().sysname
    end
end

function is_dark_mode:init_query_command()
    if self.system ~= nil and self.query_command ~= nil then
        return
    end

    if self.system == "Darwin" then
        self.query_command = { "defaults", "read", "-g", "AppleInterfaceStyle" }
    elseif self.system == "Linux" then
        if not vim.fn.executable("dbus-send") then
            error([[
        `dbus-send` is not available. The Linux implementation of
        auto-dark-mode.nvim relies on `dbus-send` being on the `$PATH`.
        ]])
        end

        self.query_command = {
            "dbus-send",
            "--session",
            "--print-reply=literal",
            "--reply-timeout=1000",
            "--dest=org.freedesktop.portal.Desktop",
            "/org/freedesktop/portal/desktop",
            "org.freedesktop.portal.Settings.Read",
            "string:org.freedesktop.appearance",
            "string:color-scheme",
        }
    elseif self.system == "WSL" then
        -- Don't swap the quotes; it breaks the code
        self.query_command = {
            "/mnt/c/Windows/system32/reg.exe",
            "Query",
            "HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
            "/v",
            "AppsUseLightTheme",
        }
    elseif self.system == "Windows_NT" then
        -- Don't swap the quotes; it breaks the code
        self.query_command = {
            "reg.exe",
            "Query",
            "HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
            "/v",
            "AppsUseLightTheme",
        }
    else
        return
    end

    if vim.fn.has("unix") ~= 0 then
        if vim.uv.os_getpid() == 0 then
            local sudo_user = vim.env.SUDO_USER

            if sudo_user ~= nil then
                self.query_command = vim.tbl_extend("keep", { "su", "-", sudo_user, "-c" }, self.query_command)
            else
                error([[
                auto-dark-mode.nvim:
                Running as `root`, but `$SUDO_USER` is not set.
                Please open an issue on `https://github.com/f-person/auto-dark-mode.nvim` to add support for your system.
                ]])
            end
        end
    end
end

function is_dark_mode:parse_query_response(res)
    if self.system == "Linux" then
        -- https://github.com/flatpak/xdg-desktop-portal/blob/c0f0eb103effdcf3701a1bf53f12fe953fbf0b75/data/org.freedesktop.impl.portal.Settings.xml#L32-L46
        -- 0: no preference
        -- 1: dark
        -- 2: light
        if string.match(res[1], "uint32 1") ~= nil then
            return true
        elseif string.match(res[1], "uint32 2") ~= nil then
            return false
        else
            -- fallback on dark
            return true
        end
    elseif self.system == "Darwin" then
        return res[1] == "Dark"
    elseif self.system == "Windows_NT" or self.system == "WSL" then
        -- AppsUseLightTheme REG_DWORD 0x0 : dark
        -- AppsUseLightTheme REG_DWORD 0x1 : light
        return string.match(res[3], "0x1") == nil
    end
    return false
end

setmetatable(is_dark_mode, {
    __call = function(self)
        self:init_system()
        self:init_query_command()
        local stdout = vim.system(self.query_command, { text = true }):wait()
        return self.parse_query_response(stdout)
    end,
})

M.is_dark_mode = is_dark_mode

readonlify_table(M)
return M
