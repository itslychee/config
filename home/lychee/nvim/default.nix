{ pkgs, ...}:
{
 programs.neovim = {
   enable = true;
   vimAlias = true;
   viAlias = true;
   defaultEditor = true;
   coc.enable = true;
   coc.settings = {
     "suggest.noselect" = true;
     "suggest.enablePreview" = true;
     "suggest.enablePreselect" = false;
     "suggest.disableKind" = true;
     "python.formatting.provider" = "${pkgs.ruff}/bin/ruff-format";
     "python.linting.ruffEnabled" = "true";
     "python.linting.flake8Enabled" = "true";
     "python.analysis.diagnosticMode" = "workspace";
     "pyright.inlayHints.variableTypes" = false;
     "suggest.triggerCompletionWait"= 35;
     "go.goplsPath" = "${pkgs.unstable.gopls}/bin/gopls";
     "go.goplsUseDaemon" = true;
     languageserver = {
       go.command = "${pkgs.unstable.gopls}/bin/gopls";
       go.rootPatterns = ["go.mod"];
       go.filetypes = ["go"];
       go."trace.server" = "verbose";
       go."go.goplsOptions" = {
         completeUnimported = true;
         local = "${pkgs.unstable.gotools}/bin/goimports -local";
       };
       # Nix 
       nix.command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
       nix.filetypes = [ "nix" ];
       # Rust
       rust.command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
       rust.filetypes = [ "rs" ];
       rust.rootPatterns = [ "Cargo.toml" ];
     };
    };
    extraConfig = builtins.readFile ./nvimrc;
    plugins = with pkgs.unstable.vimPlugins; [
      # Nvim tree
      nvim-tree-lua nvim-web-devicons
      # Language plugins
      vim-polyglot coc-go coc-pyright
      # Neat little git conflict plugin
      git-conflict-nvim
      # Theme(s)
      kanagawa-nvim
      bufferline-nvim
      alpha-nvim
      statix
      # Multi cursors!
      vim-visual-multi
      telescope-nvim
    ];
  };
}
