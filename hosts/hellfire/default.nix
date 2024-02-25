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
    ./secrets.nix
  ];

  hey.services.openssh.enable = true;

  # I don't wanna compile filesystem drivers or whatever the fuck
  # they're called.
  boot.supportedFilesystems = lib.mkForce ["ext4" "vfat"];
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  sdImage = {
    imageBaseName = config.networking.hostName;
    compressImage = false;
  };

  # Networking
  networking.firewall = {
    allowedTCPPorts = [53 80];
    allowedUDPPorts = [53 67];
  };

  # I do not care about inode dates and I want my RPI's I/O as fast
  # as possible
  fileSystems."/".options = ["noatime"];

  users.users.root.openssh.authorizedKeys.keys = inputs.self.publicSSHKeys;
  users.users.pi = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    hashedPasswordFile = config.age.secrets.pi-hellfire.path;
    openssh.authorizedKeys.keys = inputs.self.publicSSHKeys;
  };
  # do not touch #
  system.stateVersion = "24.05";
}
