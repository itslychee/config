{ config, lib, pkgs, ...}:
{
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 20;
      output = [
        "eDP-1"
        "HDMI-A-1"
      ];
      modules-left   = [ "sway/workspaces" ];
      modules-center = [ "clock" ];
      modules-right  = [ "battery" "pulseaudio" "custom/suspend" "custom/poweroff" "custom/reboot" ]; 

      "pulseaudio" = {
        format = "{volume}% ";
        format-bluetooth = " {volume}%";
        format-muted = "{volume}% ";

      };

      "sway/workspaces" = {
        disable-scroll = true;
        disable-click = true;
      };
      # Systemctl commands
      "custom/poweroff" = {
        on-click = "systemctl poweroff";
        format = "";
      };
      "custom/reboot" = {
        on-click = "systemctl reboot";
        format = "";
      };
      "custom/suspend" = {
        on-click = "systemctl suspend";
        format = "";
      };
      # Date & time
      "clock" = {
        format = "{:%A  %Y.%m.%d  %I:%M%p [%Z:%z]}";
      };
      "battery" = {
        interval = 30;
        format-icons = [ "" "" "" "" ""];
      };
    };
    style = builtins.readFile ./waybar.css; 
    systemd = {
      target = lib.mkIf config.wayland.windowManager.sway.systemdIntegration "sway-session.target";
      enable = true;
    };

  };
}
