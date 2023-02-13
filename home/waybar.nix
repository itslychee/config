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
      modules-center = [ "clock" ];
      modules-right  = [ "battery" "pulseaudio" "network" "memory"]; 

      "pulseaudio" = {
        format = "{volume}% ";
        format-bluetooth = " {volume}%";
        format-muted = "{volume}% ";
        on-right-click = "${pkgs.pamixer}/bin/pamixer -t";
      };
      "network" = {
        format-ethernet = "{ipaddr} {bandwidthUpBytes} {bandwidthDownBytes}";
        format-wifi = " {essid} {bandwidthUpBytes} {bandwidthDownBytes}";
        interval = 5;
      };
      "disk" = {
        format = "{percentage}% ";
        interval = 5;
      };
      "memory" = {
        interval = 15;
        format = "{percentage}%  {swapPercentage}% ";
      };
      "sway/workspaces" = {};
      "clock" = {
        format = "{:%A  %I:%M%p  %Y.%m.%d}";
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
