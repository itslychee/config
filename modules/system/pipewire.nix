{ lib, config, pkgs, ...}:
with lib;
{
  config = {
    services.pipewire.enable = mkDefault true;
    services.pipewire.alsa.enable = mkDefault true;
    services.pipewire.alsa.support32Bit = mkDefault true;
    services.pipewire.audio.enable = mkDefault true;
    services.pipewire.pulse.enable = mkDefault true; 
    services.pipewire.jack.enable = mkDefault true;
    hardware.pulseaudio.enable = false;
  };
}

