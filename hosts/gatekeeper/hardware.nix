# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelModules = ["kvm-intel"];
    initrd = {
      availableKernelModules = [
        "ehci_pci"
        "ahci"
        "megaraid_sas"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = ["dm-snapshot"];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/f249f7e8-7540-447a-84c6-07c20d2e20b9";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/21A8-34DC";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  swapDevices = lib.singleton {
    device = "/dev/disk/by-uuid/5274f87f-bfe8-488f-97af-e85ae63933da";
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}