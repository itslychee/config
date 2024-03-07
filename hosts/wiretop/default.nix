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
    fonts.enable = true;
    services = {
      kmscon.enable = false;
      pipewire.enable = true;
      openssh.enable = true;
    };

    users.lychee = {
      enable = true;
      wms.sway.enable = true;
      packages = [
        pkgs.firefox
      ];
    };
  };

  networking.networkmanager.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # hey cutie, don't touch!
  system.stateVersion = "24.05";
}
