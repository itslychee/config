{config, ...}: {
  boot.kernelParams = ["intel_iommu=on"];
  boot.loader.systemd-boot.enable = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  hey = {
    users.mc = {
      inherit (config.hey.users.lychee) sshKeys enable;
    };

    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICAKg9ZgbTR5ftw+nrm+Ch7Xl4LBs4z9M+e45/K0pG4u";
  };

  hey.remote.builder = {
    enable = true;
    maxJobs = 20;
    speedFactor = 100;
  };

  system.stateVersion = "23.11";
}
