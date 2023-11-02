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
       "python.formatting.provider" = "${pkgs.ruff}/bin/ruff-format";
       "python.linting.ruffEnabled" = "true";
       "python.analysis.diagnosticMode" = "workspace";
       "pyright.inlayHints.variableTypes" = false;

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
   extraConfig = builtins.readFile ./nvim/vimrc;
   plugins = with pkgs.unstable.vimPlugins; [
     vim-startify
     yankring
     vim-polyglot
     coc-pairs
     everforest
     nvim-tree-lua
     nvim-web-devicons
     coc-pyright
     seoul256-vim
     git-conflict-nvim
     vim-airline
     vim-airline-themes
   ];
 };
}
