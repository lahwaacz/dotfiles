-- not in vscode...
if not vim.g.vscode then

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config("*", {
    capabilities = capabilities,
})

require'lspconfig'.bashls.setup{
    autostart = false,
}
require'lspconfig'.pkgbuild_language_server.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.texlab.setup{}
require'lspconfig'.neocmake.setup{}

-- ruff does not have completion support
require'lspconfig'.ruff.setup{}
-- pyright does static type checking and completion
require'lspconfig'.pyright.setup{}

require'lspconfig'.cssls.setup{}
require'lspconfig'.html.setup{}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.yamlls.setup{}
require'lspconfig'.ansiblels.setup{}
require'lspconfig'.typos_lsp.setup{}
require'lspconfig'.vale_ls.setup{
    settings = {
        root_markers = {".vale.ini"},
    },
    -- do not start the lsp if none of the root markers is found
    single_file_support = false,
}

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

-- configure efmls for markdownlint-cli2
-- based on https://github.com/mattn/efm-langserver?tab=readme-ov-file#configuration-for-neovim-builtin-lsp-with-nvim-lspconfig
require "lspconfig".efm.setup {
    settings = {
        root_markers = {".git/"},
        languages = {
            markdown = {
                {
                    lintCommand = "markdownlint-cli2 -",
                    lintStdin = true,
                    lintFormats = { '%f:%l:%c %m', '%f:%l %m', '%f: %l: %m' },
                }
            }
        }
    }
}

-- configure gitlab-ci-ls
-- https://github.com/alesbrelih/gitlab-ci-ls#integration-with-neovim
vim.lsp.enable('gitlab_ci_ls')
vim.filetype.add({
  pattern = {
    ['%.gitlab%-ci%.ya?ml'] = 'yaml.gitlab',
  },
})

end
