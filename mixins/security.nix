{ config, lib, ...}:
with lib;
{
  config = mkDefault {
    security = {
      protectKernelImage = true;
      sudo.execWheelOnly = true;
      rtkit.enable = true;
    };
  };
}
