{ lib, ... }:
{
  networking.hostName = lib.mkForce "rainforest-node-2";
  boot.loader.systemd-boot.enable = true;
  hey.hostKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHiCax0o/1zd+Ry7impZRDbOn4F3ife/A1HhS0EYh1KH root@rainforest-node-2"
  ];
  system.stateVersion = "24.05";

  hey.remote.builder = {
    enable = true;
    maxJobs = 40;
    speedFactor = 105;
  };
}
