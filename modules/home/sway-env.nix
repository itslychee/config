{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkOption
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
  cfg = config.wms.sway;
in {
  options.wms.sway = {
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

  config = mkIf cfg.enable {
    root.".config/sway/config".text =
      (concatStringsSep "\n" (mapAttrsToList (k: v: "bindsym ${k} ${v}") cfg.keybindings))
      + cfg.extraConfig;

    packages = [pkgs.sway];
  };
}
