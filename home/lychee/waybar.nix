{ config, lib, pkgs, ...}:
{
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
      modules-left   = [ "sway/workspaces" ];
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
    };
    style = builtins.readFile ./waybar.css; 
    systemd = {
      target = lib.mkIf config.wayland.windowManager.sway.systemdIntegration "sway-session.target";
      enable = true;
    };

  };
}
