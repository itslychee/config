{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf mkMerge;
  inherit (lib.types) bool;
  inherit (config.hey.roles) graphical;
  nvim = inputs.nvim.packages.${pkgs.system};
in
{
  options = {
    hey.programs.neovim = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable my editor system-wide";
      };

    };
  };

  config = mkMerge [
    (mkIf graphical {
      environment.systemPackages = [ nvim.full ];
    })
    (mkIf (!graphical) {
      environment.systemPackages = [ nvim.minimal ];
    })
  ];
}
