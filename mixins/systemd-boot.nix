{ config, lib, ...}:
with lib;
{
  config = mkDefault {
    boot.loader = {
      timeout = 25;
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
