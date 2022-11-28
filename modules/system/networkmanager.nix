{ lib, config, ...}:
with lib;
{
  config.networking.networkmanager.enable = mkDefault true;
}
