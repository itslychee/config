{ config, lib, ...}:
with lib;
{
  config.boot.loader = {
    timeout = mkDefault 30;
    systemd-boot = {
      enable = mkDefault true;
      editor = mkDefault false;
      consoleMode = mkDefault "max";
    };
    efi.canTouchEfiVariables = mkDefault true;
  };
}
