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

  swapDevices = lib.singleton { device = "/dev/disk/by-uuid/8c24ced4-3a3e-412a-aed5-9211cfadb275"; };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault false;
  networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  boot.loader.grub.device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_48720426";
  system.stateVersion = "24.05";
}
