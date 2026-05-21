--- @require "lazy"
--- @type LazyPluginSpec
local M = {
	"nvim-telescope/telescope-fzf-native.nvim",
}

M.lazy = true

M.build =
	"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"

return M
