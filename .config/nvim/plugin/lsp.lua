local capabilities = require('cmp_nvim_lsp').default_capabilities()

require'lspconfig'.bashls.setup{
    autostart = false,
}
require'lspconfig'.pkgbuild_language_server.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.pylsp.setup{
    capabilities = capabilities,
}
require'lspconfig'.texlab.setup{}

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
