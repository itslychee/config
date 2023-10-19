{ pkgs, ...}:
{
 programs.neovim = {
   enable = true;
   vimAlias = true;
   viAlias = true;
   defaultEditor = true;

   coc = {
     enable = true;
     settings = {
       "suggest.noselect" = true;
       "suggest.enablePreview" = true;
       "suggest.enablePreselect" = false;
       "suggest.disableKind" = true;
       "python.venvPath" = "./.venv";
       "python.formatting.provider" = "black";
       languageserver = {
         go = {
           command = "${pkgs.gopls}/bin/gopls";
           rootPatterns = ["go.mod"];
           "trace.server" = "verbose";
           filetypes = ["go"];
         };
         nix = {
           command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
           filetypes = [ "nix" ];
         };
         rust = {
           command = "rust-analyzer";
           filetypes = [ "rust" "rs" ];
           rootPatterns = [ "Cargo.toml" ];
         };
       };
     };
   };
   extraLuaConfig = builtins.readFile ./neovim.lua;
   plugins = with pkgs.vimPlugins; [
     vim-startify
     yankring
     vim-polyglot
     coc-pairs
     everforest
     nvim-tree-lua
     nvim-web-devicons
     coc-pyright
   ];
 };
}
