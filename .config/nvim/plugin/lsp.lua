-- not in vscode...
if not vim.g.vscode then

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config("*", {
    capabilities = capabilities,
})

--vim.lsp.enable("bashls")
vim.lsp.enable("pkgbuild_language_server")
vim.lsp.enable("clangd")
vim.lsp.enable("texlab")
vim.lsp.enable("neocmake")

-- ruff does not have completion support
vim.lsp.enable("ruff")
-- pyright does static type checking and completion
vim.lsp.enable("pyright")

vim.lsp.enable("cssls")
vim.lsp.enable("html")
vim.lsp.enable("jsonls")
vim.lsp.enable("yamlls")
vim.lsp.enable("ansiblels")
vim.lsp.enable("typos_lsp")
vim.lsp.enable("vale_ls")
vim.lsp.config("vale_ls", {
    settings = {
        root_markers = {".vale.ini"},
    },
    -- do not start the lsp if none of the root markers is found
    single_file_support = false,
})

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
vim.lsp.enable("efm")
vim.lsp.config("efm", {
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
})

-- configure gitlab-ci-ls
-- https://github.com/alesbrelih/gitlab-ci-ls#integration-with-neovim
vim.lsp.enable("gitlab_ci_ls")
vim.filetype.add({
  pattern = {
    ['%.gitlab%-ci%.ya?ml'] = 'yaml.gitlab',
  },
})

end
