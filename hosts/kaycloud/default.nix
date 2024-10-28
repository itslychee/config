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

  hey.remote.builder = {
    enable = true;
    maxJobs = 10;
    speedFactor = 40;
  };
  services.terraria = {
    enable = true;
    openFirewall = true;
    port = 7777;
  };

  services.consul.extraConfig.server = true;

}
