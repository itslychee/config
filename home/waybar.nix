{ config, lib, pkgs, flags, ...}:
lib.mkIf (!flags.headless or false) {
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      height = 20;
      position = "top";
      output = [
        "eDP-1"
        "HDMI-A-1"
      ];
      modules-left   = [ "sway/workspaces" "mpris" ];
      modules-center = [ "clock" ];
      modules-right  = [ "battery" "pulseaudio"]; 

      "pulseaudio" = {
        format = "{volume}% ";
        format-bluetooth = " {volume}%";
        format-muted = "{volume}% ";
        on-right-click = "${pkgs.pamixer}/bin/pamixer -t";
      };
      "clock" = {
        format = "{:%A  %I:%M <b>%p</b>  %Y<b>.</b>%m<b>.</b>%d}";
      };
      "battery" = {
        interval = 30;
        format-icons = [ "" "" "" "" ""];
        format = "{capacity}% {icon}";
      };
      "mpris" = {
        format = "[{player}] {title} <b><i>by</i></b> {artist}";
        format-paused = "{player}: <b>paused!</b>";
        format-stopped = "{player}: <b>stopped!</b>";
        interval = 5;
        ignored-players = ["firefox"];
      };
    };
    style = builtins.readFile ./waybar.css; 
    systemd = {
      target = lib.mkIf config.wayland.windowManager.sway.systemdIntegration "sway-session.target";
      enable = true;
    };

  };
}
