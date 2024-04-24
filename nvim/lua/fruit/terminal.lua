vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    local opt = vim.opt_local
    vim.cmd.startinsert()
    opt.relativenumber = false
    opt.number = false
  end,
})

local k = vim.keymap.set
-- Add easy escape functionality like in INSERT mode
k("t", "<ESC>", "<C-\\><C-n>")
