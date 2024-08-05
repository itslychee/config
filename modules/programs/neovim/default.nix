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
  inherit (inputs.self.packages.${pkgs.system}) nvim;
  inherit (inputs.unstable.legacyPackages.${pkgs.system}.vimPlugins) nvim-treesitter;
in {
  options = {
    hey.programs.neovim = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable my editor system-wide";
      };

      grammars = mkOption {
        type = package;
        default = nvim-treesitter.withPlugins (p: [p.nix p.bash]);
      };

      noLSPs = mkEnableOption "Do not include LSPs with Neovim";

      extraLSPs = mkOption {
        type = listOf package;
        default = [];
      };
    };
  };
  config = mkMerge [
    (mkIf (!config.hey.caps.graphical) {
      hey.programs.neovim.noLSPs = true;
    })
    (mkIf config.hey.caps.graphical {
      hey.programs.neovim.grammars = nvim-treesitter.withAllGrammars;
    })
    (mkIf cfg.enable {
      environment.systemPackages = [(nvim.override {inherit (cfg) grammars noLSPs extraLSPs;})];
    })
  ];
}
