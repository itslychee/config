{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "sd_mod" "sr_mod"];
  boot.kernelModules = ["kvm-amd"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/dba3ca7c-89cc-4fb4-b83b-7775f7d70211";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B167-702E";
    fsType = "vfat";
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
