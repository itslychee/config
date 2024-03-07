{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.neovim;
  inherit (lib) mkOption;
  inherit (lib.types) package bool listOf;
in {
  options.neovim = {
    enable = mkOption {
      type = bool;
      default = true;
    };
    extraPackages = mkOption {
      default = builtins.attrValues {
        inherit
          (pkgs)
          ripgrep
          nil
          ruff-lsp
          gopls
          rust-analyzer
          ccls
          ;
        inherit (pkgs.nodePackages_latest) pyright;
      };
      apply = f: lib.makeBinPath f;
      type = listOf package;
    };
  };
  config = lib.mkIf cfg.enable {
    packages = let
      inherit (pkgs) wrapNeovimUnstable neovim-unwrapped;
      inherit (pkgs.neovimUtils) makeNeovimConfig;
      nvimConfig = makeNeovimConfig {
        vimAlias = true;
        plugins = builtins.attrValues {
          inherit
            (pkgs.vimPlugins)
            kanagawa-nvim
            nvim-lspconfig
            cmp-nvim-lsp
            nvim-cmp
            cmp-path
            cmp-buffer
            git-conflict-nvim
            nvim-web-devicons
            mini-nvim
            telescope-nvim
            cmp_luasnip
            ;
          ts = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
        };
        luaRcContent = builtins.readFile ./init.lua;
      };
    in [
      (wrapNeovimUnstable neovim-unwrapped (nvimConfig
        // {
          wrapperArgs = nvimConfig.wrapperArgs ++ ["--prefix" "PATH" ":" cfg.extraPackages];
        }))
    ];
  };
}
