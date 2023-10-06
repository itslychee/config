vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function() vim.cmd("NvimTreeToggle") end,
})

vim.api.nvim_create_autocmd({"QuitPre"}, {
  callback = function() vim.cmd("NvimTreeClose") end,
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.omnifunc = "syntaxcomplete#Complete"
vim.wo.wrap = false 

vim.cmd [[
   colorscheme everforest 
   " Use tab for trigger completion with characters ahead and navigate
   " NOTE: There's always complete item selected by default, you may want to enable
   " no select by `"suggest.noselect": true` in your configuration file
   " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
   " other plugin before putting this into your config
   inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

   " Make <CR> to accept selected completion item or notify coc.nvim to format
   " <C-g>u breaks current undo, please make your own choice
   inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                         \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
]]

require "nvim-web-devicons".setup()
require "nvim-tree".setup({
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  update_focused_file = {
    enable = true,
  },
  tab = {
    sync = {
      open = true;
    },
  },
})


vim.api.nvim_set_keymap('i', '<m-x>', "<cmd>lua require 'nvim-tree.api'.tree.toggle(false, true)<CR>",
{ noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<m-x>', "<cmd>lua require 'nvim-tree.api'.tree.toggle(false, true)<CR>",
{ noremap = true, silent = true })
