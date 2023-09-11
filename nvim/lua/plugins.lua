local result = {
    { import = 'common.plugins' }
}

local platform_import
if vim.g.vscode then
    platform_import = 'vscode.plugins'
else
    platform_import = 'nvim.plugins'
end

table.insert(result, { import = platform_import })
return result
