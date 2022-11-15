{ config, pkgs, ...}:
with pkgs.lib;
{
  config.services.autofs.enable = mkDefault true;
}
