{ 
  noFirewall ? false, 
  extraUDPPorts ? [], 
  extraTCPPorts ? [],
  hostName
}:
{ config, lib, ...}:
with lib;
{
  config = mkDefault {
    networking = {
      inherit hostName;
      networkmanager = {
      	enable = true;
      	enableFccUnlock = true;
      };
      firewall = {
        enable = !noFirewall;
        allowedUDPPorts = [ 80 443 ] ++ extraUDPPorts;
        allowedTCPPorts = [ 80 443 ] ++ extraTCPPorts;
      };
    };
  };
}
