{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

    ./blocky.nix
  ];

  # relevant issue(s):
  # https://github.com/NixOS/nixpkgs/issues/154163
  #
  # using 6.7 as latest is broken due to zfs-kernel being marked as broken
  # >:(

  boot.kernelPackages = pkgs.linuxPackages_6_7_hardened;
  boot.supportedFilesystems = ["ext4" "vfat"];

  sdImage = {
    imageBaseName = config.networking.hostName;
    compressImage = false;
  };

  users.users.lychee.openssh.authorizedKeys.keys = config.hey.keys.users.lychee.local_ssh;
  fileSystems."/".options = ["noatime"];
  hey = {
    caps = {
      headless = true;
      rootLogin = true;
    };
    users.lychee.enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };

  networking.interfaces.end0.useDHCP = true;

  # do not touch #
  system.stateVersion = "24.05";
}
