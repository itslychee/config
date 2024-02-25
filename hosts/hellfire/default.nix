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

  # thanks mjm!
  services.blocky = {
    enable = true;
    settings = {
      upstreams = {
        init.strategy = "failOnError"; # this must work!
        groups.default = [
          # CloudFlare
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
      };
      blocking.blackLists.ads = [
        "https://raw.githubusercontent.com/StevenBlack/hosts/d75a9114c4d96438e710dd6686c431bd48108752/hosts"
      ];
    };
  };
  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };

  # do not touch #
  system.stateVersion = "24.05";
}
