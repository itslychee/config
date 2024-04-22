{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption optional;
  inherit (lib.types) package nullOr;
in {
  programs = {
    ssh = {
      enable = true;
      compression = true;
      addKeysToAgent = "yes";
    };

    git = {
      enable = true;
      package = pkgs.gitFull;
      difftastic.enable = true;
      userName = "itslychee";
      userEmail = "itslychee@protonmail.com";
      signing = {
        signByDefault = true;
        key = "~/.ssh/id_ed25519";
      };
      extraConfig.gpg.format = "ssh";
      ignores = [
        "*.swp"
        "*~"
      ];
    };
  };
  home.packages = let
    nvim-config = pkgs.neovimUtils.makeNeovimConfig {
      plugins = builtins.attrValues {
        inherit
          (pkgs.vimPlugins)
          cmp-async-path
          cmp-buffer
          cmp-cmdline
          cmp-nvim-lsp
          cmp_luasnip
          conform-nvim
          git-conflict-nvim
          kanagawa-nvim
          lualine-nvim
          luasnip
          mini-nvim
          nvim-cmp
          nvim-lspconfig
          nvim-web-devicons
          telescope-nvim
          ;
        ts = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
      };
      wrapRc = false;
    };
  in [
    ((pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped nvim-config).overrideAttrs (old: {
      generatedWrapperArgs =
        old.generatedWrapperArgs
        or []
        ++ [
          "--set"
          "NVIM_APPNAME"
          "neovim"
          "--set"
          "XDG_CONFIG_HOME"
          ../../nvim
          "--suffix"
          "PATH"
          ":"
          (lib.makeBinPath (builtins.attrValues {
            inherit
              (pkgs)
              alejandra
              gotools
              rustfmt
              ruff
              nil
              statix
              ;
          }))
        ];
    }))
  ];
}
