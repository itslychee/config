local cmd = vim.cmd
local o = vim.opt
local api = vim.api
local k = vim.keymap.set
local colorscheme = vim.cmd.colorscheme

-- Theme setup!
o.background = "light"
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
o.completeopt = "menu,menuone,noinsert"

vim.g.mapleader = ","

require "fruit.terminal"
require "fruit.lsp"
require "fruit.formatting"
require "fruit.telescope"
require "fruit.treesitter"

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
