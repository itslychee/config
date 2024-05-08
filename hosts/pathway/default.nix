# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hey = {
    caps = {
      graphical = true;
      headless = true;
    };
    net.home = true;
    users.lychee = {
      state = "24.05";
      sshKeys = config.hey.keys.users.lychee.local_ssh;
      wms.sway = {
        enable = true;
      };
      packages = [
        pkgs.firefox
        pkgs.xdg-utils
        pkgs.qbittorrent
      ];
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
