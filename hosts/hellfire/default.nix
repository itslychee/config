{
  lib,
  config,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  # relevant issue(s):
  # https://github.com/NixOS/nixpkgs/issues/154163
  #
  # using 6.7 as latest is broken due to zfs-kernel being marked as broken
  # >:(
  boot.kernelPackages = pkgs.linuxPackages;
  boot.supportedFilesystems = ["ext4" "vfat"];
  nixpkgs.overlays = [
    (final: prev: {
      libcec = prev.libcec.override {withLibraspberrypi = true;};
    })
  ];

  sdImage = {
    imageBaseName = config.networking.hostName;
    compressImage = false;
  };

  fileSystems."/".options = ["noatime"];
  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILxxBfeFvi0urMaWvg610+EUvl4xJu0R1oZ0edMVJD2U";
    caps.headless = true;
    caps.graphical = true;
    # add phone to keys
    users.lychee.enable = lib.mkForce false;
    users.viewer = {
      enable = true;
      groups = ["video" "uinput"];
    };
  };
  services.kmscon.enable = lib.mkForce false;
  services.greetd.enable = lib.mkForce false;
  services.displayManager.sddm = {
    enable = true;
    settings = {
      Autologin = {
        User = "viewer";
        Session = "plasma-bigscreen-x11.desktop";
        Relogin = true;
      };
    };
  };

  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5 = {
    bigscreen.enable = true;
  };

  # do not touch #
  system.stateVersion = "24.05";
}
