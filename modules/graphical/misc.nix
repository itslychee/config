{
  config,
  lib,
  ...
}: {
  programs.dconf.enable = lib.mkDefault config.hey.caps.graphical;
  hardware.opengl.enable = lib.mkDefault config.hey.caps.graphical;
}
