{ config, pkgs, ...}:
with pkgs.lib;
{
  config.programs.light.enable = mkDefault true;
}
