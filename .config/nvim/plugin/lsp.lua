-- not in vscode...
if not vim.g.vscode then

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require'lspconfig'.bashls.setup{
    autostart = false,
    capabilities = capabilities,
}
require'lspconfig'.pkgbuild_language_server.setup{
    capabilities = capabilities,
}
require'lspconfig'.clangd.setup{
    capabilities = capabilities,
}
require'lspconfig'.texlab.setup{
    capabilities = capabilities,
}
require'lspconfig'.neocmake.setup {
    capabilities = capabilities,
}

-- ruff does not have completion support
require'lspconfig'.ruff.setup{}
-- pyright does static type checking and completion
require'lspconfig'.pyright.setup{
    capabilities = capabilities,
}

require'lspconfig'.cssls.setup{}
require'lspconfig'.html.setup{}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.yamlls.setup{}
require'lspconfig'.ansiblels.setup{}

-- starh bashls for filetype=sh, but not filename=PKGBUILD
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "sh",
        callback = function()
            if vim.fn.expand('%') ~= 'PKGBUILD' and not vim.fn.expand('%'):match('.*/PKGBUILD$') then
                vim.lsp.start({
                    name = 'bash-language-server',
                    cmd = { 'bash-language-server', 'start' },
                })
            end
        end
    }
)

end
