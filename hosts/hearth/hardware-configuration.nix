{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
  boot.kernel.sysctl = {
      "vm.swappiness" = 30;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/dba3ca7c-89cc-4fb4-b83b-7775f7d70211";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B167-702E";
    fsType = "vfat";
  };

  fileSystems."/storage" = {
    device = "/dev/disk/by-label/Storage";
    fsType = "ntfs";
    options = ["noatime"];
  };

  swapDevices = [{device = "/dev/disk/by-uuid/d5493993-21a0-40e2-a63f-32d6e3586129";}];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
