{ pkgs, config, ...}:
let
  swaySystemd = config.wayland.windowManager.sway.systemd.enable;
in {
  programs.waybar.enable = true;
  programs.waybar.settings.mainBar = {
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
  programs.waybar.systemd.enable = true;
  programs.waybar.systemd.target = pkgs.lib.mkIf swaySystemd "sway-session.target";
  programs.waybar.style = builtins.readFile ./waybar.css;

}
