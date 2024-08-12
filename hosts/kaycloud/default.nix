{
  config,
  lib,
  nodes,
  ...
}: {
  hey.caps.headless = true;
  networking.networkmanager.enable = false;

  networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
    allowedTCPPorts = [22000 8384];
    allowedUDPPorts = [21027 22000];
  };

  # IPv6 public IP
  systemd.network = {
    enable = true;
    networks.ipv6 = {
      matchConfig.Name = "enp1s0";
      networkConfig = {
        Address = "2a01:4ff:f0:cb64::1/64";
        Gateway = "fe80::1";
      };
    };
  };
}
