local pick = require "mini.pick"
pick.setup {
  options = {
    use_cache = true,
  },
}

local k = vim.keymap.set

k("n", "<leader>f", function()
  pick.builtin.files { tool = "git" }
end, { desc = "[pick] Find git files" })
k("n", "<leader>F", function()
  pick.start {
    source = { items = vim.fn.readdir "." },
  }
end, { desc = "[pick] Find files in current directory" })
k("n", "<leader>g", pick.builtin.grep, {
  desc = "[pick] Grep",
})
