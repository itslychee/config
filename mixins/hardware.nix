{ config, lib, ...}:
with lib;
{
  config = mkOverride 100 {
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
