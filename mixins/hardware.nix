{ config, lib, ...}:
with lib;
{
  config = mkDefault {
    hardware = {
      enableAllFirmware = true;
      bluetooth.enable = true;
      acpilight.enable = true;
      opengl = {
      	enable = true;
        driSupport = true;
      };
    };
  };
}
