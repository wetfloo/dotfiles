return {
	"norcalli/nvim-colorizer.lua",
	priority = 1000,
	lazy = false,
	config = function()
		require("colorizer").setup()
	end,
}
