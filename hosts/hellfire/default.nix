{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  # relevant issue(s):
  # https://github.com/NixOS/nixpkgs/issues/154163
  #
  # using 6.7 as latest is broken due to zfs-kernel being marked as broken
  # >:(

  boot.kernelPackages = pkgs.linuxPackages;
  boot.supportedFilesystems = ["ext4" "vfat"];

  sdImage = {
    imageBaseName = config.networking.hostName;
    compressImage = false;
  };

  fileSystems."/".options = ["noatime"];
  hey = {
    caps = {
      headless = true;
      rootLogin = true;
    };
    # add phone to keys
    users.lychee = {
      sshKeys = config.hey.keys.users.lychee.local_ssh;
    };
  };

  # do not touch #
  system.stateVersion = "24.05";
}
