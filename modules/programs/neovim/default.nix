{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.hey.programs.neovim;
  inherit (lib) mkOption mkIf mkMerge mkEnableOption;
  inherit (lib.types) bool package listOf;
  inherit (inputs.unstable.legacyPackages.${pkgs.system}.vimPlugins) nvim-treesitter;
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
  config = mkIf cfg.enable (mkMerge [
    (mkIf (!config.hey.caps.graphical) {
      environment.systemPackages = lib.singleton nvim.minimal;
    })
    (mkIf config.hey.caps.graphical {
      environment.systemPackages = lib.singleton (nvim.full.override (old: {
        extraBinaries = (old.extraBinaries or []) ++ cfg.extraLSPs;
      }));
    })
  ]);
}
