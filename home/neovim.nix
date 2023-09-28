{ pkgs, ...}:
{
 programs.neovim = {
   enable = true;
   vimAlias = true;
   viAlias = true;

   coc = {
     enable = true;
     settings = {
       "suggest.noselect" = true;
       "suggest.enablePreview" = true;
       "suggest.enablePreselect" = false;
       "suggest.disableKind" = true;
       languageserver = {
         # Language servers
         # nix = {
         #   command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
         #   filetypes = [ "nix" ];
         # };
         rust = {
           command = "rust-analyzer";
           filetypes = [ "rust" "rs" ];
           rootPatterns = [ "Cargo.toml" ];
         };
       };
     };
   };
   extraLuaConfig = ''
     vim.api.nvim_create_autocmd({"QuitPre"}, {
       callback = function() vim.cmd("NvimTreeClose") end,
     })

     vim.g.loaded_netrw = 1
     vim.g.loaded_netrwPlugin = 1

     vim.opt.termguicolors = true
     vim.opt.number = true
     vim.wo.wrap = false 

     vim.cmd [[ colorscheme everforest ]]

     require "nvim-web-devicons".setup()
     require "nvim-tree".setup({
       open_on_setup = true,
       ignore_buffer_on_setup = true,
       renderer = {
         group_empty = true,
       },
       filters = {
         dotfiles = true,
       },
       update_focused_file = {
         enable = true,
       },
     })
     
     vim.api.nvim_set_keymap('i', '<m-x>', "<cmd>lua require 'nvim-tree.api'.tree.toggle(false, true)<CR>",
     { noremap = true, silent = true })
     vim.api.nvim_set_keymap('n', '<m-x>', "<cmd>lua require 'nvim-tree.api'.tree.toggle(false, true)<CR>",
     { noremap = true, silent = true })
   '';
   plugins = with pkgs.vimPlugins; [
     vim-startify
     yankring
     vim-nix
     vim-polyglot
     coc-pairs
     everforest
     nvim-tree-lua
     nvim-web-devicons
   ];
 };
}
