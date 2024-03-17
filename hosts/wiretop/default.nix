{
  pkgs,
  config,
  lib,
  ...
}: {
  boot = {
    loader.systemd-boot.enable = true;
    initrd.availableKernelModules = ["xhci_pci" "usb_storage" "sd_mod" "sdhci_pci"];
    kernelModules = ["kvm-intel"];
  };

  hey = {
    caps = {
        graphical = true;
        headless = true;
    };
    net.home = true;
    users.lychee = {
      enable = true;
      wms.sway.enable = true;
      packages = [
        pkgs.firefox
      ];
    };
  };

  services.fwupd.enable = true;
  networking.networkmanager.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # hey cutie, don't touch!
  system.stateVersion = "24.05";
}
