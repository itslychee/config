{ config, lib, ...}:
with lib;
{
  # OpenGL
  config.hardware.opengl = {
    enable = mkDefault true;
    driSupport32Bit = mkDefault true;
  };
}
