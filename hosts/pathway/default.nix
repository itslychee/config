# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.ssh.agentTimeout = lib.mkForce "1m";
  hey = {
    caps = {
      graphical = true;
      headless = true;
    };
    net.home = true;
    users.lychee = {
      state = "24.05";
      sshKeys = config.hey.keys.users.lychee.local_ssh;
      wms.sway.enable = true;
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
