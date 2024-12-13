-- Documentation: https://github.com/okuuva/auto-save.nvim

-- not in vscode...
if not vim.g.vscode then

require("auto-save").setup {
    -- activate on startup
    enabled = true,
    -- delay after which a pending save is executed
    debounce_delay = 5000,
}

local group = vim.api.nvim_create_augroup('autosave', {})

vim.api.nvim_create_autocmd('User', {
    pattern = 'AutoSaveWritePost',
    group = group,
    callback = function(opts)
        if opts.data.saved_buffer ~= nil then
            local filename = vim.api.nvim_buf_get_name(opts.data.saved_buffer)
            print('AutoSave: saved ' .. filename .. ' at ' .. vim.fn.strftime('%H:%M:%S'))
        end
    end,
})

end
