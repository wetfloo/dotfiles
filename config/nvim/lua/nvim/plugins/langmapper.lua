return {
	"Wansmer/langmapper.nvim",
	enabled = require("utils").dir_contains(vim.fn.getcwd(), ".+%.tex") and false,
	lazy = false,
	priority = 999,
	config = function()
		local function escape(str)
			-- You need to escape these characters to work correctly
			local escape_chars = [[;,."|\]]
			return vim.fn.escape(str, escape_chars)
		end

		--- @param cmds string | table
		--- @return number
		local function executable(cmds)
			local result = 1
			if type(cmds) == "table" then
				for _, cmd in ipairs(cmds) do
					result = result and vim.fn.executable(cmd)
				end
				return result
			elseif type(cmds) == "string" then
				return vim.fn.executable(cmds)
			else
				return 0
			end
		end

		-- Recommended to use lua template string
		local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
		local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
		local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
		local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

		vim.opt.langmap = vim.fn.join({
			escape(ru) .. ";" .. escape(en),
			escape(ru_shift) .. ";" .. escape(en_shift),
		}, ",")

		local langmapper = require("langmapper")
		langmapper.setup({
			hack_keymap = true,
			disable_hack_modes = { "i" },
			automapping_modes = { "n", "v", "x", "s" },
			layouts = {
				ru_linux_sway = {
					id = "Russian",
					layout = [[йцукенгшщзхъ\фывапролджэячсмитьбю.ЙЦУКЕНГШЩЗХЪ/ФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,"№?]],
					default_layout = [[qwertyuiop[]\asdfghjkl;'zxcvbnm,./QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?@#&]],
				},
			},
			os = {
				-- The result of `vim.loop.os_uname().sysname`.
				Linux = {
					---Function for getting current keyboard layout on your OS
					---Seems to be called only when the key is not in the current langmap
					---Should return string with id of layout
					---@return string | nil
					get_current_layout_id = function()
						local cmds = { "swaymsg", "jq" }
						if executable(cmds) then
							local output = vim.trim(
								vim.fn.system(
									[[swaymsg -t get_inputs | jq -r 'map(select(.type=="keyboard"))[0].xkb_active_layout_name']]
								)
							)
							return output
						end
					end,
				},

				Darwin = {
					default_layout = [[ABCDEFGHIJKLMNOPQRSTUVWXYZ<>:"{}~abcdefghijklmnopqrstuvwxyz,.;'[]`]],
					layouts = {
						ru = {
							id = "com.apple.keylayout.RussianWin",
							layout = [[ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯБЮЖЭХЪËфисвуапршолдьтщзйкыегмцчнябюжэхъё]],
							default_layout = nil,
						},
					},
					get_current_layout_id = function()
						local cmd = "im-select"
						if executable(cmd) then
							local output = vim.split(vim.trim(vim.fn.system(cmd)), "\n")
							return output[#output]
						end
					end,
				},
			},
		})
		langmapper.hack_get_keymap()
	end,
}
