{
  config,
  lib,
  ...
}: {
  programs.dconf.enable = lib.mkDefault config.hey.caps.graphical;
}
