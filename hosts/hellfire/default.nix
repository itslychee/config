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
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICzt2XbvnHZf0gPn68PNMW5jj2YrPfKo1plVh2Dtle+j";
    caps.headless = true;
    # add phone to keys
    users.lychee = {
      sshKeys = config.hey.keys.lychee.local_ssh;
    };
  };

  # do not touch #
  system.stateVersion = "24.05";
}
