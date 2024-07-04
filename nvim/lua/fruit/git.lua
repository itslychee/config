require("git-conflict").setup {
  default_mappings = {
    ours = "o",
    theirs = "t",
    none = "0",
    both = "b",
    next = "n",
    prev = "p",
  },
}

vim.api.nvim_create_autocmd("User", {
  pattern = "FugitiveEditor",
  callback = function()
    local opt = vim.opt_local
    vim.cmd.startinsert()
    -- opt.relativenumber = false
    -- opt.number = false
    opt.signcolumn = "no"
  end,
})
