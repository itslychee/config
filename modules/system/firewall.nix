{ config, lib, ...}:
with lib;
{
  config = {
    networking.firewall.allowedTCPPorts = mkDefault [ 80 443 ];
    networking.firewall.allowedUDPPorts = mkDefault [ 80 443 ];
    networking.firewall.enable = mkDefault true;
  };
}
