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

  fileSystems."/".options = ["noatime"];
  fileSystems."/home/viewer/.cache" = {
    device = "none";
    fsType = "tmpfs";
  };

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
    blacklistedKernelModules = ["bluetooth"];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  sdImage = {
    imageBaseName = config.networking.hostName;
    compressImage = false;
  };

  # A server does not need this to be on anyways
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  hey = {
    hostKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK99Mee2XhXeWBm5bhNULCwCHIK6wNIRO+Svzyf2xsQn"];
    caps.headless = true;
    caps.graphical = true;
    users.viewer = {
      enable = true;
      groups = ["video" "uinput"];
    };
    users.lychee.enable = lib.mkForce false;
  };
  services.kmscon.enable = lib.mkForce false;
  services.greetd.enable = lib.mkForce false;

  # Bigscreen
  services.xserver.desktopManager.plasma5.bigscreen.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      Autologin = {
        User = "viewer";
        Session = "plasma-bigscreen-wayland";
        Relogin = true;
      };
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      libcec = prev.libcec.override {withLibraspberrypi = true;};
    })
  ];

  # do not touch #
  system.stateVersion = "24.05";
}
