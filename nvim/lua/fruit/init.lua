local cmd = vim.cmd
local o = vim.opt
local api = vim.api
local k = vim.keymap.set
local colorscheme = vim.cmd.colorscheme

-- Theme setup!
o.background = "dark"
colorscheme "kanagawa"

-- Options
o.splitbelow = true
o.wrap = false
o.number = true
o.relativenumber = true
o.expandtab = true
o.cursorline = true
o.splitright = true
o.splitbelow = true
o.termguicolors = true
o.shiftwidth = 4
o.timeoutlen = 550
o.cmdheight = 1
o.ignorecase = true
o.signcolumn = "yes"
o.completeopt = "menu,menuone,noinsert"

-- Folds -- stolen from @mrshmllow
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldenable = false

o.showbreak = "↪ "
o.list = true
o.listchars = "lead:.,tab:▎·,trail:."

vim.g.mapleader = " "

require "fruit.terminal"
require "fruit.lsp"
require "fruit.git"
require "fruit.formatting"
require "fruit.pickin"
require "fruit.treesitter"
require("which-key").setup {}
require("mini.comment").setup {
  options = {
    custom_commentstring = function()
      return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
    end,
  },
}
require("mini.sessions").setup()
require("mini.pairs").setup()
require("mini.files").setup {
  windows = {
    max_number = 3,
    preview = true,
    width_preview = 50,
  },
  options = {
    permanent_delete = true,
    use_as_default_explorer = true,
  },
}
require("lualine").setup { options = { theme = "dracula" } }

k("n", "-", require("mini.files").open)
