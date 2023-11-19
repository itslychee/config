{ pkgs, ...}:
{
  # Idling manager
  services.swayidle.enable = true;
  services.swayidle.timeouts = let 
    swaymsg = "${pkgs.sway}/bin/swaymsg";
  in [
    {
      timeout = 300;
      command = "${swaymsg} 'output * dpms off';";
      resumeCommand = "${swaymsg} 'output * dpms on'";
    }
  ];
  wayland.windowManager.sway.enable = true;
  wayland.windowManager.sway.systemd.enable = true;
  wayland.windowManager.sway.extraConfig = ''
    input "type:touchpad" {
      tap enabled
      scroll_method two_finger
    }
    input "type:keyboard" {
      dwt enabled
    }
    for_window [app_id="firefox"] inhibit_idle fullscreen
    for_window [app_id="Firefox"] inhibit_idle fullscreen
    workspace 1
  '';

  wayland.windowManager.sway.config = {
    bars = [];
    gaps.smartGaps = true;
    gaps.inner = 5;
    focus.followMouse = "no";
    colors.focused = {
      border = "#ec6c6e"; 
      childBorder = "#ffa9d2"; 
      background = "#9d4849";
      text = "#efefef"; 
      indicator = "#ffd7e8";
    };
    output.HDMI-A-1.bg = "~/.wallpaper-image fill";
    output.HDMI-A-1.mode = "1920x1080@144.001Hz";
    output.HDMI-A-1.adaptive_sync = "on";
  };

  # Keybindings
  wayland.windowManager.sway.config.keybindings = let
    pamixer = "${pkgs.pamixer}/bin/pamixer";
    player = "${pkgs.playerctl}/bin/playerctl --player='spotify,mpd,%any'";
    modifier = "Mod4";
  in {
   Print = "exec wayshot -c -s \"`slurp -f '%x %y %w %h'`\" --stdout | wl-copy -t image/png";
   "Shift+Print" = "exec wayshot -c -s \"`slurp -f '%x %y %w %h'`\" --stdout | swappy -f - -o - | wl-copy -t image/png";
   XF86AudioRaiseVolume = "exec ${pamixer} -i 2";
   XF86AudioLowerVolume = "exec ${pamixer} -d 2";
   XF86AudioMute = "exec ${pamixer} -t";
   XF86AudioStop = "exec ${player} stop";
   XF86AudioPrev = "exec ${player} previous";
   XF86AudioPlay = "exec ${player} play-pause";
   XF86AudioNext = "exec ${player} next";
   XF86MonBrightnessUp   = "exec light -A 5";
   XF86MonBrightnessDown = "exec light -U 5";
   "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
   "${modifier}+Space" = "exec ${pkgs.fuzzel}/bin/fuzzel";
   "${modifier}+shift+escape" = "exit";
   "${modifier}+h" = "focus left";
   "${modifier}+j" = "focus down";
   "${modifier}+k" = "focus up";
   "${modifier}+l" = "focus right";
   "${modifier}+u" = "focus mode_toggle";
   "${modifier}+z" = "workspace 1";
   "${modifier}+x" = "workspace 2";
   "${modifier}+c" = "workspace 3";
   "${modifier}+v" = "workspace 4";
   "${modifier}+b" = "workspace 5";
   "${modifier}+bracketright" = "workspace next";
   "${modifier}+bracketleft" = "workspace prev";
   "${modifier}+w" = "kill";
   "${modifier}+s" = "sticky toggle";
   "${modifier}+d" = "floating toggle";
   "${modifier}+f" = "fullscreen toggle";
   "${modifier}+shift+h" = "move left";
   "${modifier}+shift+j" = "move down";
   "${modifier}+shift+k" = "move up";
   "${modifier}+shift+l" = "move right";
   "${modifier}+shift+z" = "move window to workspace 1";
   "${modifier}+shift+x" = "move window to workspace 2";
   "${modifier}+shift+c" = "move window to workspace 3";
   "${modifier}+shift+v" = "move window to workspace 4";
   "${modifier}+shift+b" = "move window to workspace 5";
   "${modifier}+left" = "resize shrink width 5";
   "${modifier}+right" = "resize grow width 5";
   "${modifier}+up" = "resize grow height 5";
   "${modifier}+down" = "resize shrink height 5";
  };
}
