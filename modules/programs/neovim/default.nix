{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.hey.programs.neovim;
  inherit (lib) mkOption mkIf mkMerge;
  inherit (lib.types) bool package;
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
    };
  };
  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = [(nvim.override {inherit (cfg) grammars;})];
    })
    (mkIf config.hey.caps.graphical {
      hey.programs.neovim.grammars = nvim-treesitter.withAllGrammars;
    })
  ];
}
