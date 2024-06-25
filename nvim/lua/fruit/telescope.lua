local pick = require "mini.pick"
pick.setup {
  options = {
    use_cache = true,
  },
  mappings = {
    move_up = "<C-k>",
    move_down = "<C-j>",
  },
}

local k = vim.keymap.set

k("n", "<leader>f", function()
  pick.builtin.files { tool = "git" }
end)
k("n", "<leader>F", function()
  pick.start {
    source = { items = vim.fn.readdir "." },
  }
end)
k("n", "<leader>g", pick.builtin.grep)
