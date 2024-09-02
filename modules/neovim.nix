{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.hey.programs.neovim;
  inherit (lib) mkOption mkIf mkMerge;
  inherit (lib.types) bool package listOf;
  inherit (config.hey.roles) graphical;
  nvim = inputs.nvim.packages.${pkgs.system};
in {
  options = {
    hey.programs.neovim = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable my editor system-wide";
      };

      extraLSPs = mkOption {
        type = listOf package;
        default = [];
      };
    };
  };

  config = mkMerge [
    (mkIf graphical {
      environment.systemPackages = [nvim.full];
    })
    (mkIf (!graphical) {
      environment.systemPackages = [nvim.minimal];
    })
  ];
}
