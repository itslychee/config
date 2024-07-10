{pkgs, ...}: {
  boot = {
    loader.systemd-boot.enable = true;
    initrd.availableKernelModules = ["xhci_pci" "usb_storage" "sd_mod" "sdhci_pci"];
    kernelModules = ["kvm-intel"];
  };

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIINnq/AyE9T+4uA4/707mECHbt+5ZzeaK3zFW4AUEMvi";
    caps = {
      graphical = true;
      headless = true;
    };
    users.lychee = {
      state = "24.05";
      wms.sway.enable = true;
      packages = [pkgs.firefox pkgs.minicom];
    };
  };

  services.fwupd.enable = true;
  hardware.cpu.intel.updateMicrocode = true;

  # hey cutie, don't touch!
  system.stateVersion = "24.05";
}
