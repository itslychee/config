{ config, lib, ...}:
with lib;
{
  config = mkOverride 100 {
    security = {
      protectKernelImage = true;
      sudo.execWheelOnly = true;
      rtkit.enable = true;
      polkit.enable = true;
    };
  };
}
