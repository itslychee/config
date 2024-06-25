vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    local opt = vim.opt_local
    vim.cmd.startinsert()
    opt.relativenumber = false
    opt.number = false
    opt.signcolumn = "no"
  end,
})

local k = vim.keymap.set
-- Add easy escape functionality like in INSERT mode
k("n", "<leader>t", vim.cmd.terminal, { desc = "Open Terminal" })
-- C-\ C-N is really annoying
k("t", "<ESC>", "<C-\\><C-N>")
