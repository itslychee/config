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

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = false;
  # networking.interfaces.enp10s0.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp9s0.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
