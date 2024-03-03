{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit
    (lib)
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
      root.".config/sway/config".text =
        (
          concatStringsSep "\n"
          (
            mapAttrsToList (k: v: "bindsym ${k} ${v}")
            (lib.filterAttrs (_: v: v != null) sway.keybindings)
          )
        )
        + sway.extraConfig;

      packages = [pkgs.swayfx pkgs.wl-clipboard];
    })
  ];
}
