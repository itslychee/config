{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkIf;
in {
  programs.light.enable = mkDefault config.hey.caps.graphical;
  programs.dconf.enable = mkDefault config.hey.caps.graphical;
  hardware.opengl.enable = mkDefault config.hey.caps.graphical;
  environment.systemPackages = mkIf config.hey.caps.graphical [
    pkgs.wl-clipboard
    pkgs.xdg-utils
  ];
  hey.programs.neovim.extraLSPs = mkIf config.hey.caps.graphical [
    pkgs.typst
    pkgs.typstyle
    pkgs.typstfmt
    pkgs.typst-lsp
  ];
}
