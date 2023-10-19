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
vim.opt.signcolumn = "yes"
vim.wo.wrap = false 

vim.cmd [[
   colorscheme everforest 

   function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
   endfunction

   set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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
   
   nnoremap <silent> K :call ShowDocumentation()<CR>
   " Use `[g` and `]g` to navigate diagnostics
   " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
   nmap <silent> [g <Plug>(coc-diagnostic-prev)
   nmap <silent> ]g <Plug>(coc-diagnostic-next)

   " GoTo code navigation
   nmap <silent> gd <Plug>(coc-definition)
   nmap <silent> gy <Plug>(coc-type-definition)
   nmap <silent> gi <Plug>(coc-implementation)
   nmap <silent> gr <Plug>(coc-references)
   " Symbol renaming
   nmap <leader>rn <Plug>(coc-rename)

   " Formatting selected code
   xmap <leader>f  <Plug>(coc-format-selected)
   nmap <leader>f  <Plug>(coc-format-selected)

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
