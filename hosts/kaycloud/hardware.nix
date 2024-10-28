{
  lib,
  modulesPath,
  ...
}:
{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];
  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/665c48da-0296-472a-9695-164fe32c9162";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/b8f05de7-a669-457d-8274-355e98c33c8f"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = false;

  systemd.network = {
    enable = true;
    networks.ipv6 = {
      matchConfig.Name = "enp1s0";
      networkConfig = {
        Address = "2a01:4ff:f0:cb64::1/64";
        DHCP = "ipv4";
        Gateway = "fe80::1";
      };
    };
  };

  boot.loader.grub.device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_48720426";
  system.stateVersion = "24.05";
}
