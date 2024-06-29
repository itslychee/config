{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkIf;
in {
  programs.dconf.enable = mkDefault config.hey.caps.graphical;
  hardware.opengl.enable = mkDefault config.hey.caps.graphical;
  environment.systemPackages = mkIf config.hey.caps.graphical [
    pkgs.wl-clipboard
    pkgs.xdg-utils
  ];
}
