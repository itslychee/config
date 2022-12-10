{ config, lib, ...}:
with lib;
{
  config = {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    networking.firewall.allowedUDPPorts = [ 80 443 ];
    networking.firewall.enable = true;
  };
}
