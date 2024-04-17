
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = "*",
    callback = function()
        local opt = vim.opt_local
        opt.relativenumber = false
        opt.number = false
    end,
})

