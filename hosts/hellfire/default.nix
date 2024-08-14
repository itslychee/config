{
  config,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  fileSystems."/".options = ["noatime"];

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
    # hostKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK99Mee2XhXeWBm5bhNULCwCHIK6wNIRO+Svzyf2xsQn"];
    hostKeys = [];
    caps.headless = true;
  };

  # do not touch #
  system.stateVersion = "24.05";
}
