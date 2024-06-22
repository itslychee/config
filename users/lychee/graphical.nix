{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) getExe mkIf;
  cfg = config.wayland.windowManager.sway;
in {
  home.packages = mkIf cfg.enable (builtins.attrValues {
    inherit
      (pkgs)
      wayshot
      wl-clipboard
      slurp
      swappy
      ;
  });
  services.playerctld.enable = config.programs.waybar.enable;
  services.mako = {
    enable = cfg.enable;
    defaultTimeout = 30;
  };
  programs.waybar = {
    enable = cfg.enable;
    settings.mainBar = {
      layer = "top";
      height = 20;
      position = "top";
      output = [
        "eDP-1"
        "HDMI-A-1"
      ];
      modules-left = ["sway/workspaces" "mpris"];
      modules-center = ["clock"];
      modules-right = ["battery" "pulseaudio"];

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
        format-icons = ["" "" "" "" ""];
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
    style = builtins.readFile ./style.css;
    systemd.enable = true;
  };

  programs.rofi = {
    enable = cfg.enable;
    package = pkgs.rofi-wayland;
    terminal = getExe pkgs.alacritty;
    font = "Terminus 10";
    extraConfig = {
      modes = "drun,window,ssh";
    };

    theme = "${pkgs.rofi-wayland}/share/rofi/themes/Paper.rasi";
  };
}
