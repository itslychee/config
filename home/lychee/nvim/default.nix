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
      # Ruff
      "ruff.useDetectRuffCommand" = false;
      "ruff.path" = "${pkgs.unstable.ruff}/bin/ruff";
      "ruff.serverPath" = "${pkgs.unstable.ruff-lsp}/bin/ruff-lsp";
      "ruff.trace.server" = "verbose";

      languageserver = {
        golang = {
          command = "${pkgs.unstable.gopls}/bin/gopls";
          rootPatterns = ["go.mod"];
          filetypes = ["go"];
          "trace.server" = "verbose";
          "go.goplsOptions" = {
            completeUnimported = true;
            local = "${pkgs.unstable.gotools}/bin/goimports -local";
          };
        };
        python = {
          command = "${pkgs.ruff}/bin/ruff";
          rootPatterns = ["pyproject.toml" "setup.py"];
          filetypes = ["py"];
        };
        # Nix
        nix = {
          command = "${lib.getExe pkgs.nil}";
          rootPatterns = ["flake.nix"];
          filetypes = ["nix"];
          settings.nil = {formatting.command = ["nix" "fmt"];};
        };
        # Rust
        rust = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          filetypes = ["rs"];
          rootPatterns = ["Cargo.toml"];
        };
      };
    };
    extraConfig = builtins.readFile ./nvimrc;
    plugins = with pkgs.unstable.vimPlugins; [
      coc-ruff
      # syntax highlighting

      # Nvim tree
      nvim-tree-lua
      nvim-web-devicons
      # Language plugins
      vim-polyglot
      coc-go
      coc-pyright
      # Neat little git conflict plugin
      git-conflict-nvim
      # Theme(s)
      kanagawa-nvim
      # tab-like ui
      bufferline-nvim
      alpha-nvim
      statix
      # Multi cursors!
      vim-visual-multi
      telescope-nvim

      editorconfig-nvim
    ];
  };
}
