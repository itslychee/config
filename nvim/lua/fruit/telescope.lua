local ts = require("telescope.builtin")
local k = vim.keymap.set
k("n", "<leader>f", ts.find_files)
k("n", "<leader>G", ts.live_grep)
k("n", "<leader>g", ts.git_files)
k("n", "<leader>b", ts.buffers)
