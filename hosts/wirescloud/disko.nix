{
  disko.devices.disk = {
    vda = {
      device = "/dev/disk/by-id/ata-QEMU_DVD-ROM_QM00001";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            end = "500M";
            type = "EF00";
            content = {
              filesystem = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "filesystem";
              format = "bcachefs";
              mountpoint = "/";
            };

          };
        };
      };
    };
  };

}
