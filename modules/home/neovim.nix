{
  pkgs,
  config,
  lib,
  ...
}: {
  options.neovim.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };

  config = lib.mkIf config.neovim.enable {
    packages = let
      inherit (pkgs) wrapNeovimUnstable neovim-unwrapped;
      inherit (pkgs.neovimUtils) makeNeovimConfig;
    in [
      (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (makeNeovimConfig {
        makeWrapperArgs = ["--suffix PATH : ${lib.getExe pkgs.ripgrep}"];
        vimAlias = true;
        plugins = builtins.attrValues {
          inherit (pkgs.vimPlugins) kanagawa-nvim;
        };
        luaRcContent = ''
          vim.o.background = "light"
          vim.cmd [[ colorscheme kanagawa ]]
        '';
      }))
    ];
  };
}
