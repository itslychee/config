{
  disk = {
    vdb = {
      device = "/dev/disk/by-id/mmc-DA4064_0xd91cf13e";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            end = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            name = "root";
            end = "-0";
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
