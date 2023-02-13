{ config, pkgs, flags, ...}:
with pkgs.lib;
{
  services = {
    mpdris2.enable = config.services.mpd.enable;
    mpd = {
      enable = !flags.headless or true;
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
  };
  # Systemd configurations
  systemd.user = {
    services = mkIf config.services.mpd.enable {
      mpdris2.Service.Restart = mkForce "always";
      mpd.Service.Restart = mkForce "always";
    };
  };
}
