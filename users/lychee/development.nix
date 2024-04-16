{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.programs.neovim) treesitter;
  inherit (lib) mkOption optional;
  inherit (lib.types) package nullOr;
in {
  options.programs.neovim.treesitter = mkOption {
    type = nullOr package;
    default = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
    description = "Treesitter package to use";
  };
  config = {
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

      neovim = {
        enable = true;
        defaultEditor = true;
        extraPackages = builtins.attrValues {
          inherit
            (pkgs)
            ripgrep
            nil
            ;
        };
        plugins =
          (builtins.attrValues {
            inherit
              (pkgs.vimPlugins)
              cmp-buffer
              cmp-nvim-lsp
              cmp-path
              cmp_luasnip
              git-conflict-nvim
              kanagawa-nvim
              luasnip
              lualine-nvim
              mini-nvim
              nvim-cmp
              nvim-lspconfig
              nvim-web-devicons
              telescope-nvim
              noice-nvim
              ;
          })
          ++ optional (treesitter != null) treesitter;

        withPython3 = true;
        withNodeJs = true;
        vimdiffAlias = true;
        vimAlias = true;
        viAlias = true;
        extraLuaConfig = builtins.readFile ./init.lua;
      };
    };
  };
}
