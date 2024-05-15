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

local neogit = require "neogit"
neogit.setup {}

vim.keymap.set("n", "<leader>i", function()
  neogit.open { kind = "split" }
end)
