{
  config,
  lib,
  ...
}:
{
  hey.hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAnZoLOT6p4Pkad9YGTiVQvYTWuT6nG1UN2TeMacMNoG";

  networking = {
    networkmanager.enable = lib.mkForce false;
    firewall.allowedTCPPorts = [
      80
      443
    ];
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

  hey.remote.builder = {
    enable = true;
    maxJobs = 10;
    speedFactor = 40;
  };

  services.consul.extraConfig.server = true;

  networking.firewall.allowedUDPPorts = [ 3478 ];
}
