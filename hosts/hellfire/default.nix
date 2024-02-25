{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  # I don't wanna compile filesystem drivers or whatever the fuck
  # they're called.
  boot.supportedFilesystems = lib.mkForce ["ext4" "vfat"];
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  sdImage = {
    imageBaseName = config.networking.hostName;
    compressImage = false;
  };

  fileSystems."/".options = ["noatime"];

  hey = {
    services.openssh.enable = true;
    users.lychee.enable = true;
  };
  users.users.root.openssh.authorizedKeys.keys = lib.flatten (builtins.attrValues config.hey.keys.privileged);

  # do not touch #
  system.stateVersion = "24.05";
}
