{
  inputs,
  mylib,
  config,
  pkgs, 
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

    ./blocky.nix
  ];

  boot = {
    # I do not want to compile any filesystem driver other than the ones listed.
    supportedFilesystems = lib.mkForce ["ext4" "vfat"];
    kernelPackages = lib.mkForce pkgs.linuxPackages;
  };

  sdImage = {
    imageBaseName = config.networking.hostName;
    compressImage = false;
  };

  fileSystems."/".options = ["noatime"];
  hey = {
    services.openssh.enable = true;
    users.lychee.enable = true;
  };

  users.users.root = {
    openssh.authorizedKeys.keys = lib.flatten (builtins.attrValues config.hey.keys.privileged);
  };

  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };

  networking.interfaces.end0.useDHCP = true;

  # do not touch #
  system.stateVersion = "24.05";
}
