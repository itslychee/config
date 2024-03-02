local cmd = vim.cmd
local o = vim.opt
local api = vim.api
local k = vim.keymap.set
local lspconfig = require("lspconfig")

o.bg = "light"
cmd.colorscheme "kanagawa"

o.splitbelow = true
o.number = true
o.relativenumber = true
o.expandtab = true
o.cursorline = true
o.splitright = true
o.splitbelow = true
o.cmdheight = 1
o.smartindent = true
o.termguicolors = true
o.backup = true
o.backupdir = "/tmp";
o.cindent = true
vim.g.mapleader = ","

api.nvim_create_autocmd('TermOpen', {
    pattern = "*",
    callback = function()
        local opt = vim.opt_local
        opt.relativenumber = false
        opt.number = false
        vim.cmd [[ startinsert ]]
    end,
})

-- LSP setup
lspconfig.nil_ls.setup  { autostart = true, }
lspconfig.gopls.setup   { autostart = true, }
lspconfig.clangd.setup  { autostart = true, }
lspconfig.ruff_lsp.setup{ autostart = true, }

-- git conflict handler!!
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

ts = require("telescope.builtin")

-- keymaps
k("n", "<leader>f", ts.find_files)
k("n", "<leader>g", ts.git_files)
k("n", "<leader>b", ts.buffers)
k("n", "-", require("mini.files").open)



