{
  config,
  lib,
  inputs,
  ...
}: {
  hey = {
    hostKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAnZoLOT6p4Pkad9YGTiVQvYTWuT6nG1UN2TeMacMNoG"
    ];
    caps.headless = true;
  };
  networking.networkmanager.enable = lib.mkForce false;

  networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
    allowedTCPPorts = [22000 8384];
    allowedUDPPorts = [21027 22000];
  };
  services.consul = {
    enable = true;
    extraConfig.server = true;
  };
  services.garage.enable = true;

  services.tailscale.ip = "100.94.118.87";
  networking.firewall.allowedTCPPorts = [80 443];
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

  hey.remote.builder = {
    enable = true;
    maxJobs = 10;
    speedFactor = 40;
  };
}
