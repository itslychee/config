{ config, lib, ...}:
with lib;
{
  config.programs.gnupg.agent = {
    enable = mkDefault true;
    pinentryFlavor = mkDefault "tty";
  };


}
