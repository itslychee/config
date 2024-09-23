{
  config,
  lib,
  ...
}:
{
  boot.kernelParams = [ "intel_iommu=on" ];
  boot.loader.systemd-boot.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  networking.hostName = lib.mkForce "rainforest-node-1";

  hey = {
    users.mc = {
      inherit (config.hey.users.lychee) sshKeys enable;
    };

    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSuccGN1fYQQqKWK5Eg+Ldj7H1a6LDIJsXxI3646Jgg";
  };

  hey.remote.builder = {
    enable = true;
    maxJobs = 20;
    speedFactor = 100;
  };

  services.consul.extraConfig = {
    server = true;
  };
  system.stateVersion = "24.05";
}
