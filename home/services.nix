{ config, pkgs, flags, ...}:
with pkgs.lib;
{
  services = {
    mpdris2.enable = config.services.mpd.enable;
    mpd = {
      enable = !flags.headless or false;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire"
          auto_resample "no"
          use_mmap "yes"
        }
      '';
      musicDirectory = /storage/media/music;
    };
    flameshot = {
      enable = !flags.headless or false;
      settings = {
          General = {
            disabledTrayIcon = true;
            showStartupLaunchMessage = false;
          };
      };
    };
  };
  # Systemd configurations
  systemd.user = {
    services = mkIf config.services.mpd.enable {
      mpdris2.Service.Restart = mkForce "always";
      mpd.Service.Restart = mkForce "always";
    };
  };
}
