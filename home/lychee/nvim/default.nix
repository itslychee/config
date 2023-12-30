{
  pkgs,
  lib,
  ...
}: {
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
      "suggest.triggerCompletionWait" = 25;

      languageserver = {
        golang = {
          command = lib.getExe pkgs.gopls;
          rootPatterns = ["go.mod"];
          filetypes = ["go"];
          "trace.server" = "verbose";
          "go.goplsOptions" = {
            completeUnimported = true;
            local = "${pkgs.gotools}/bin/goimports -local";
          };
        };
        python = {
          command = lib.getExe' pkgs.ruff-lsp "ruff-lsp";
          rootPatterns = [
            "pyproject.toml"
            "setup.py"
            "requirements.txt"
          ];
          filetypes = [ "python" ];
        };

        sh = {
          command = lib.getExe pkgs.shellcheck;
          filetypes = [ "sh" ];
        };

        nix = {
          command = lib.getExe pkgs.nil;
          rootPatterns = ["flake.nix"];
          filetypes = ["nix"];
          settings.nil = {formatting.command = ["nix fmt"];};
        };
        # Rust
        rust = {
          command = lib.getExe pkgs.rust-analyzer;
          filetypes = ["rs" "rust"];
          rootPatterns = ["Cargo.toml"];
        };
      };
    };
    extraConfig = builtins.readFile ./nvimrc;
    plugins = with pkgs.vimPlugins; [
      # Nvim tree
      nvim-tree-lua
      nvim-web-devicons
      # Language plugins
      vim-polyglot
      coc-go
      coc-diagnostic
      # Neat little git conflict plugin
      git-conflict-nvim
      # Theme(s)
      kanagawa-nvim
      # tab-like ui
      bufferline-nvim
      # Multi cursors!
      vim-visual-multi
      telescope-nvim

      editorconfig-nvim
    ];
  };
}
