{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) getExe mkIf;
  cfg = config.wayland.windowManager.sway;
in {
  home.packages = mkIf cfg.enable (builtins.attrValues {
    inherit
      (pkgs)
      wayshot
      wl-clipboard
      slurp
      swappy
      ;
  });
  services.playerctld.enable = config.programs.waybar.enable;
  services.mako.enable = true;
}
