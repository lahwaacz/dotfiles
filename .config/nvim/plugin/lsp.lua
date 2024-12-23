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

-- ruff does not have completion support
require'lspconfig'.ruff.setup{}
-- https://github.com/pappasam/jedi-language-server#configuration
--require'lspconfig'.jedi_language_server.setup{
--    capabilities = capabilities,
--    init_options = {
--        jediSettings = {
--            autoImportModules = {"numpy", "pandas", "vtk"},
--        },
--    },
--}
-- pylsp just dispatches everything to plugins (jedi for completion and those
-- disabled below for diagnostics), but for some reason it actually works better
-- than jedi-language-server which can't load the vtk module
require'lspconfig'.pylsp.setup{
    capabilities = capabilities,
    -- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
    settings = {
        pylsp = {
            plugins = {
                -- disable all plugins which duplicate ruff functionality
                autopep8 = { enabled = false },
                flake8 = { enabled = false },
                mccabe = { enabled = false },
                pycodestyle = { enabled = false },
                pydocstyle = { enabled = false },
                pyflakes = { enabled = false },
                pylint = { enabled = false },
                yapf = { enabled = false },
            }
        }
    }
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
