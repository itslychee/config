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
      modules-left   = [ "sway/workspaces" "custom/music" ];
      modules-center = [ "sway/window" ];
      modules-right  = [ "battery" "pulseaudio" "clock"]; 

      "pulseaudio" = {
        format = "{volume}% ";
        format-bluetooth = " {volume}%";
        format-muted = "{volume}% ";
        on-right-click = "${pkgs.pamixer}/bin/pamixer -t";
      };
      "disk" = {
        format = "{percentage}% ";
        interval = 5;
      };
      "clock" = {
        format = "{:%A  %I:%M%p  %Y.%m.%d}";
      };
      "sway/window" = {
        max-length = 60;
      };
      "battery" = {
        interval = 30;
        format-icons = [ "" "" "" "" ""];
        format = "{capacity}% {icon}";
      };
      "custom/music" = {
        max-length = 50;
        exec = "${pkgs.playerctl}/bin/playerctl metadata -Ff '[{{duration(position)}}|{{default(duration(mpris:length), \"??:??\")}}] {{markup_escape(artist)}} | {{markup_escape(trunc(title, 35))}} '";
      };
    };
    style = builtins.readFile ./waybar.css; 
    systemd = {
      target = lib.mkIf config.wayland.windowManager.sway.systemdIntegration "sway-session.target";
      enable = true;
    };

  };
}
