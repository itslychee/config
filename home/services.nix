{ config, pkgs, flags, ...}:
with pkgs.lib;
{
  services = {
    mpdris2.enable = config.services.mpd.enable;
    playerctld.enable = !flags.headless or false;
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
    dunst = {
      enable = !flags.headless or false;
      configFile = pkgs.writeText "config" ''
        [global]
          frame_color = "#ff99d2"
          sort = no
          offset = 10x20
          frame_width = 1
          padding = 6
          font = Terminus 10 
          gap_size = 2
          format = "<b>%a:</b><i>%s</i>\n%b"
          show_indicators = false
          browser = ${pkgs.xdg-utils}/bin/xdg-open
          corner_radius = 5
          width = 500
          height = 800
          stack_duplicates = false
          history_length = 10

        [urgency_normal]
          background = "#4f5b82"
          timeout = 10s 
      '';
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
