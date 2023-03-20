{ 
  noFirewall ? false, 
  extraUDPPorts ? [], 
  extraTCPPorts ? [],
  Fail2Ban ? { enable = false; extraRanges = []; },
  hostName
}:
{ config, lib, ...}:
with lib;
{
  config = ({
    networking = {
      inherit hostName;
      networkmanager = {
        enable = true;
        enableFccUnlock = true;
      };
      firewall = mkIf (!noFirewall) {
        enable = true;
        allowedUDPPorts = extraUDPPorts;
        allowedTCPPorts = extraTCPPorts;
      };
    };
    services.fail2ban = {
      enable = Fail2Ban.enable or false;
      maxretry = 5;
      ignoreIP = [
        # LAN ranges both in IPv6 and IPv4
        "127.0.0.0/8"
        "10.0.0.0/8"
        "::1/128"
      ] ++ Fail2Ban.extraRanges or [];
    };
  });
}
