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

vim.keymap.set("n", "`", "<cmd>LazyGit<CR>", { desc = "lazygit" })
