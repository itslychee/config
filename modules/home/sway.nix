{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    flatten
    mkOption
    mkMerge
    mkIf
    mapAttrsToList
    concatStringsSep
    mkEnableOption
    ;
  inherit
    (lib.types)
    attrsOf
    str
    lines
    ;
  sway = config.wms.sway;
in {
  options = {
    wms.sway = {
      enable = mkEnableOption "Sway";
      keybindings = mkOption {
        type = attrsOf str;
        default = {};
      };
      extraConfig = mkOption {
        type = lines;
        default = "";
      };
    };
  };

  config = mkMerge [
    # Sway
    (mkIf sway.enable {
      switches.opengl = true;
      root.".config/sway/config".source = pkgs.writeText "home-sway" (concatStringsSep "\n" (flatten [
        (mapAttrsToList (k: v: "bindsym ${k} ${v}") sway.keybindings)
        sway.extraConfig
      ]));

      packages = [pkgs.swayfx pkgs.wl-clipboard];
    })
  ];
}
