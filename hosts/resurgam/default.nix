{
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.efiSysMountPoint = "/boot/EFI";
      grub = {
        enable = true;
        efiSupport = true;
        mirroredBoots = [
          {
            devices = [ "nodev" ];
            path = "/boot/ESP0";
          }
          {
            devices = [ "nodev" ];
            path = "/boot/ESP1";
          }
        ];
      };
    };
    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];
  };

  hey = {
    hostKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICryQMXcQiTjSwPIB2+6dZ27nDu7UvjzsICiF2+8C9RC"
    ];
    users.lychee = {
      groups = [
        "docker"
      ];
    };
  };

  # eno1np0

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  services.gns3-server = {
    enable = true;
    dynamips.enable = true;
    vpcs.enable = true;
    ubridge.enable = true;
  };
}
