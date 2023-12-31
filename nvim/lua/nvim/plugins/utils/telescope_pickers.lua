--- Nicer pickers for telescope, made by
--- https://github.com/nvim-telescope/telescope.nvim/issues/2014#issuecomment-1690573382
local M = {}

-- Store Utilities we'll use frequently
local telescope_utils = require('telescope.utils')
local telescope_make_entry = require('telescope.make_entry')
local telescope_entry_display = require('telescope.pickers.entry_display')

-- Obtain Filename icon width
-- --------------------------
-- INSIGHT: This width applies to all icons that represent a file type
local file_type_icon_width = require('plenary.strings')
    .strdisplaywidth(require('nvim-web-devicons').get_icon('fname', { default = true }))

---- Helper functions ----

-- Gets the File Path and its Tail (the file name) as a Tuple
local function get_path_and_tail(filename)
    -- Get the Tail
    local buffer_name_trail = telescope_utils.path_tail(filename)

    -- Now remove the tail from the Full Path
    local path_without_trail = require('plenary.strings').truncate(filename, #filename - #buffer_name_trail, '')

    -- Apply truncation and other pertaining modifications to the path according to Telescope path rules
    local path_to_display = telescope_utils.transform_path({
        path_display = { 'truncate' },
    }, path_without_trail)

    -- Return as Tuple
    return buffer_name_trail, path_to_display
end

---- Picker functions ----

-- Generates a Find File picker but beautified
-- -------------------------------------------
-- This is a wrapping function used to modify the appearance of pickers that provide a Find File
-- functionality, mainly because the default one doesn't look good. It does this by changing the 'display()'
-- function that Telescope uses to display each entry in the Picker.
--
-- Adapted from: https://github.com/nvim-telescope/telescope.nvim/issues/2014#issuecomment-1541423345.
--
-- @param (table) picker_opts - A table with the following format:
--                                   {
--                                      picker = '<pickerName>',
--                                      (optional) options = { ... }
--                                   }
function M.pretty_files_picker(picker_opts)
    -- Parameter integrity check
    if type(picker_opts) ~= 'table' or picker_opts.picker == nil then
        print("Incorrect argument format. Correct format is: { picker = 'desiredPicker', (optional) options = { ... } }")

        -- Avoid further computation
        return
    end

    -- Ensure 'options' integrity
    local options = picker_opts.options or {}

    -- Use Telescope's existing function to obtain a default 'entry_maker' function
    -- ----------------------------------------------------------------------------
    -- INSIGHT: Because calling this function effectively returns an 'entry_maker' function that is ready to
    --          handle entry creation, we can later call it to obtain the final entry table, which will
    --          ultimately be used by Telescope to display the entry by executing its 'display' key function.
    --          This reduces our work by only having to replace the 'display' function in said table instead
    --          of having to manipulate the rest of the data too.
    local og_entry_maker = telescope_make_entry.gen_from_file(options)

    -- INSIGHT: 'entry_maker' is the hardcoded name of the option Telescope reads to obtain the function that
    --          will generate each entry.
    -- INSIGHT: The paramenter 'line' is the actual data to be displayed by the picker, however, its form is
    --          raw (type 'any) and must be transformed into an entry table.
    options.entry_maker = function(line)
        -- Generate the Original Entry table
        local og_entry_table = og_entry_maker(line)

        -- INSIGHT: An "entry display" is an abstract concept that defines the "container" within which data
        --          will be displayed inside the picker, this means that we must define options that define
        --          its dimensions, like, for example, its width.
        local displayer = telescope_entry_display.create({
            separator = ' ', -- Telescope will use this separator between each entry item
            items = {
                { width = file_type_icon_width },
                { width = nil },
                { remaining = true },
            },
        })

        -- LIFECYCLE: At this point the "displayer" has been created by the create() method, which has in turn
        --            returned a function. This means that we can now call said function by using the
        --            'displayer' variable and pass it actual entry values so that it will, in turn, output
        --            the entry for display.
        --
        -- INSIGHT: We now have to replace the 'display' key in the original entry table to modify the way it
        --          is displayed.
        -- INSIGHT: The 'entry' is the same Original Entry Table but is is passed to the 'display()' function
        --          later on the program execution, most likely when the actual display is made, which could
        --          be deferred to allow lazy loading.
        --
        -- HELP: Read the 'make_entry.lua' file for more info on how all of this works
        og_entry_table.display = function(entry)
            -- Get the Tail and the Path to display
            local tail, path_to_display = get_path_and_tail(entry.value)

            -- Add an extra space to the tail so that it looks nicely separated from the path
            local tail_for_display = tail .. ' '

            -- Get the Icon with its corresponding Highlight information
            local icon, icon_highlight = telescope_utils.get_devicons(tail)

            -- INSIGHT: This return value should be a tuple of 2, where the first value is the actual value
            --          and the second one is the highlight information, this will be done by the displayer
            --          internally and return in the correct format.
            return displayer({
                { icon,          icon_highlight },
                tail_for_display,
                { path_to_display, 'TelescopeResultsComment' },
            })
        end

        return og_entry_table
    end

    -- Finally, check which file picker was requested and open it with its associated options
    if picker_opts.picker == 'find_files' then
        require('telescope.builtin').find_files(options)
    elseif picker_opts.picker == 'git_files' then
        require('telescope.builtin').git_files(options)
    elseif picker_opts.picker == 'oldfiles' then
        require('telescope.builtin').oldfiles(options)
    elseif picker_opts.picker == '' then
        print("Picker was not specified")
    else
        print("Picker is not supported by Pretty Find Files")
    end
end

-- Generates a Grep Search picker but beautified
-- ----------------------------------------------
-- This is a wrapping function used to modify the appearance of pickers that provide Grep Search
-- functionality, mainly because the default one doesn't look good. It does this by changing the 'display()'
-- function that Telescope uses to display each entry in the Picker.
--
-- @param (table) picker_opts - A table with the following format:
--                                   {
--                                      picker = '<pickerName>',
--                                      (optional) options = { ... }
--                                   }
function M.pretty_grep_picker(picker_opts)
    -- Parameter integrity check
    if type(picker_opts) ~= 'table' or picker_opts.picker == nil then
        print("Incorrect argument format. Correct format is: { picker = 'desiredPicker', (optional) options = { ... } }")

        -- Avoid further computation
        return
    end

    -- Ensure 'options' integrity
    local options = picker_opts.options or {}

    -- Use Telescope's existing function to obtain a default 'entry_maker' function
    -- ----------------------------------------------------------------------------
    -- INSIGHT: Because calling this function effectively returns an 'entry_maker' function that is ready to
    --          handle entry creation, we can later call it to obtain the final entry table, which will
    --          ultimately be used by Telescope to display the entry by executing its 'display' key function.
    --          This reduces our work by only having to replace the 'display' function in said table instead
    --          of having to manipulate the rest of the data too.
    local og_entry_maker = telescope_make_entry.gen_from_vimgrep(options)

    -- INSIGHT: 'entry_maker' is the hardcoded name of the option Telescope reads to obtain the function that
    --          will generate each entry.
    -- INSIGHT: The paramenter 'line' is the actual data to be displayed by the picker, however, its form is
    --          raw (type 'any) and must be transformed into an entry table.
    options.entry_maker = function(line)
        -- Generate the Original Entry table
        local og_entry_table = og_entry_maker(line)

        -- INSIGHT: An "entry display" is an abstract concept that defines the "container" within which data
        --          will be displayed inside the picker, this means that we must define options that define
        --          its dimensions, like, for example, its width.
        local displayer = telescope_entry_display.create({
            separator = ' ', -- Telescope will use this separator between each entry item
            items = {
                { width = file_type_icon_width },
                { width = nil },
                { width = nil }, -- Maximum path size, keep it short
                { remaining = true },
            },
        })

        -- LIFECYCLE: At this point the "displayer" has been created by the create() method, which has in turn
        --            returned a function. This means that we can now call said function by using the
        --            'displayer' variable and pass it actual entry values so that it will, in turn, output
        --            the entry for display.
        --
        -- INSIGHT: We now have to replace the 'display' key in the original entry table to modify the way it
        --          is displayed.
        -- INSIGHT: The 'entry' is the same Original Entry Table but is is passed to the 'display()' function
        --          later on the program execution, most likely when the actual display is made, which could
        --          be deferred to allow lazy loading.
        --
        -- HELP: Read the 'make_entry.lua' file for more info on how all of this works
        og_entry_table.display = function(entry)
            ---- Get File columns data ----
            -------------------------------

            -- Get the Tail and the Path to display
            local tail, path_to_display = get_path_and_tail(entry.filename)

            -- Get the Icon with its corresponding Highlight information
            local icon, icon_highlight = telescope_utils.get_devicons(tail)

            ---- Format Text for display ----
            ---------------------------------

            -- Add coordinates if required by 'options'
            local coordinates = ""

            if not options.disable_coordinates then
                if entry.lnum then
                    if entry.col then
                        coordinates = string.format(" -> %s:%s", entry.lnum, entry.col)
                    else
                        coordinates = string.format(" -> %s", entry.lnum)
                    end
                end
            end

            -- Append coordinates to tail
            tail = tail .. coordinates

            -- Add an extra space to the tail so that it looks nicely separated from the path
            local tail_for_display = tail .. ' '

            -- Encode text if necessary
            local text = options.file_encoding and vim.iconv(entry.text, options.file_encoding, "utf8") or entry.text

            -- INSIGHT: This return value should be a tuple of 2, where the first value is the actual value
            --          and the second one is the highlight information, this will be done by the displayer
            --          internally and return in the correct format.
            return displayer({
                { icon,          icon_highlight },
                tail_for_display,
                { path_to_display, 'TelescopeResultsComment' },
                text
            })
        end

        return og_entry_table
    end

    -- Finally, check which file picker was requested and open it with its associated options
    if picker_opts.picker == 'live_grep' then
        require('telescope.builtin').live_grep(options)
    elseif picker_opts.picker == 'grep_string' then
        require('telescope.builtin').grep_string(options)
    elseif picker_opts.picker == '' then
        print("Picker was not specified")
    else
        print("Picker is not supported by Pretty Grep Picker")
    end
end

local kind_icons = {
    Text = "",
    String = "",
    Array = "",
    Object = "󰅩",
    Namespace = "",
    Method = "m",
    Function = "󰊕",
    Constructor = "",
    Field = "",
    Variable = "󰫧",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
    Copilot = "🤖",
    Boolean = "",
}

function M.pretty_document_symbols(local_opts)
    if local_opts ~= nil and type(local_opts) ~= 'table' then
        print("Options must be a table.")
        return
    end

    local options = local_opts or {}

    local og_entry_maker = telescope_make_entry.gen_from_lsp_symbols(options)

    options.entry_maker = function(line)
        local og_entry_table = og_entry_maker(line)

        local displayer = telescope_entry_display.create({
            separator = ' ',
            items = {
                { width = file_type_icon_width },
                { width = 20 },
                { remaining = true },
            },
        })

        og_entry_table.display = function(entry)
            return displayer {
                string.format("%s", kind_icons[(entry.symbol_type:lower():gsub("^%l", string.upper))]),
                { entry.symbol_type:lower(), 'TelescopeResultsVariable' },
                { entry.symbol_name,         'TelescopeResultsConstant' },
            }
        end

        return og_entry_table
    end

    require('telescope.builtin').lsp_document_symbols(options)
end

function M.pretty_workspace_symbols(local_opts)
    if local_opts ~= nil and type(local_opts) ~= 'table' then
        print("Options must be a table.")
        return
    end

    local options = local_opts or {}

    local og_entry_maker = telescope_make_entry.gen_from_lsp_symbols(options)

    options.entry_maker = function(line)
        local og_entry_table = og_entry_maker(line)

        local displayer = telescope_entry_display.create({
            separator = ' ',
            items = {
                { width = file_type_icon_width },
                { width = 15 },
                { width = 30 },
                { width = nil },
                { remaining = true },
            },
        })

        og_entry_table.display = function(entry)
            local tail, _ = get_path_and_tail(entry.filename)
            local tail_for_display = tail .. ' '
            local path_to_display = telescope_utils.transform_path({
                path_display = { shorten = { num = 2, exclude = { -2, -1 } }, 'truncate' },

            }, entry.value.filename)

            return displayer {
                string.format("%s", kind_icons[(entry.symbol_type:lower():gsub("^%l", string.upper))]),
                { entry.symbol_type:lower(), 'TelescopeResultsVariable' },
                { entry.symbol_name,         'TelescopeResultsConstant' },
                tail_for_display,
                { path_to_display, 'TelescopeResultsComment' },
            }
        end

        return og_entry_table
    end

    require('telescope.builtin').lsp_dynamic_workspace_symbols(options)
end

function M.pretty_buffers_picker(local_opts)
    if local_opts ~= nil and type(local_opts) ~= 'table' then
        print("Options must be a table.")
        return
    end

    local options = local_opts or {}

    local og_entry_maker = telescope_make_entry.gen_from_buffer(options)

    options.entry_maker = function(line)
        local og_entry_table = og_entry_maker(line)

        local displayer = telescope_entry_display.create {
            separator = " ",
            items = {
                { width = file_type_icon_width },
                { width = nil },
                { width = nil },
                { remaining = true },
            },
        }

        og_entry_table.display = function(entry)
            local tail, path = get_path_and_tail(entry.filename)
            local tail_for_display = tail .. ' '
            local icon, icon_highlight = telescope_utils.get_devicons(tail)

            return displayer {
                { icon,                      icon_highlight },
                tail_for_display,
                { '(' .. entry.bufnr .. ')', "TelescopeResultsNumber" },
                { path,                      "TelescopeResultsComment" },
            }
        end

        return og_entry_table
    end

    require('telescope.builtin').buffers(options)
end

return M
