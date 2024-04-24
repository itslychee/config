local ts = require("telescope.builtin")
local k = vim.keymap.set
k("n", "<leader>f", ts.find_files)
k("n", "<leader>g", ts.live_grep)
k("n", "<leader>G", ts.git_files)
k("n", "<leader>b", ts.buffers)
