require("fruit.terminal")
require("fruit.lsp")
require("fruit.formatting")


require 'git-conflict'.setup({
    default_mappings = {
        ours = 'o',
        theirs = 't',
        none = "0",
        both = "b",
        next = "n",
        prev = "p",
    },
})

require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
      enable = true,
  },
}

local ts = require("telescope.builtin")
local cmd = vim.cmd
local o = vim.opt
local api = vim.api
local k = vim.keymap.set

cmd.colorscheme "kanagawa"

o.splitbelow = true
o.wrap = false
o.number = true
o.relativenumber = true
o.expandtab = true
o.cursorline = true
o.splitright = true
o.splitbelow = true
o.termguicolors = true
o.background = "light";
o.cindent = true
o.shiftwidth = 4
o.completeopt = "menu,menuone,noselect"
vim.g.mapleader = ","

require('lualine').setup{ options = { theme = "dracula" } }

vim.filetype.add { filename = { [".envrc"] = "bash", }}

-- keymaps
k("n", "-", require("mini.files").open)
k("n", "<leader>f", ts.find_files)
k("n", "<leader>g", ts.live_grep)
k("n", "<leader>b", ts.buffers)
k("t", "<ESC>", "<C-\\><C-n>")
k("n", "<space>e", vim.diagnostic.open_float)
k("n", "[d", vim.diagnostic.goto_prev)
k("n", "]d", vim.diagnostic.goto_next)
k("n", "<space>q", vim.diagnostic.setloclist)
vim.keymap.set("n", "<space>f", function()
    require("conform").format()
end, { noremap = true, silent = true, buffer = bufnr, desc = "Format document" })
