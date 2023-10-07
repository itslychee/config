{ config, lib, ...}:
with lib;
{
  config = mkOverride 100 {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
