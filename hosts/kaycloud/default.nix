{config, ...}: {
  hey.caps.headless = true;
  networking.networkmanager.enable = false;

  networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
    allowedTCPPorts = [22000 8384];
    allowedUDPPorts = [21027 22000];
  };
}
