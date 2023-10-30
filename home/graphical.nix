{ pkgs, lib, flags, ...}:
lib.mkIf (!flags.headless or false) {  
  home.pointerCursor = { 
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = with builtins; let
    common = {
      gtk-enable-primary-paste = "false";
    };
    commonTransformed =
      lib.concatStrings (lib.mapAttrsToList (k: v: "{k} = {v}\n") common);
  in {
    enable = true;
    iconTheme = {
      package = pkgs.luna-icons;
      name = "Luna-Dark";
    };
    theme = {
      name = "Yaru-Pink";
      package = pkgs.fetchFromGitHub {
        owner = "Jannomag";
        repo = "Yaru-Colors";
        rev = "74f8179dab3ab0d0ac9858883815ff7941e74c0f";
        sha256 = "sha256-sEATCqjMBn6LwgMQcL8pvEW4k6WAMjOpSbSO3ksQPEU=";
      };
    };
    gtk2.extraConfig = commonTransformed;
    gtk3.extraConfig = common;
    gtk4.extraConfig = common;
  };


  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    extraConfig = ''
      input "type:touchpad" {
        tap enabled
        scroll_method two_finger
      }
      input "type:keyboard" {
        dwt enabled
      }
      workspace 1
    '';
    config = rec {
      bars = [];
      gaps = {
        smartGaps = true;
        inner = 6;
      };
      focus.followMouse = "no";
      colors = rec {
          # focusedInactive = {};
          # placeholder = {};
          # unfocused = {};
          focused = {
            border = "#ec6c6e"; 
            childBorder = "#ffa9d2"; 
            background = "#9d4849";
            text = "#efefef"; 
            indicator = "#ffd7e8";
          };
        };
      output = {
        HDMI-A-1 = {
          bg = "~/.wallpaper-image fill";
          mode = "1920x1080@144.001Hz";
          adaptive_sync = "on";
        }; 
      };
      modifier = "Mod4";
      keybindings = let
        pamixer = "${pkgs.pamixer}/bin/pamixer";
        player = "${pkgs.playerctl}/bin/playerctl --player='spotify,mpd,%any'";
      in {
         # Launch Terminal
         "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
         "${modifier}+Space" = "exec ${pkgs.fuzzel}/bin/fuzzel";
         "${modifier}+shift+escape" = "exit";

         # Volume keybinds
         XF86AudioRaiseVolume = "exec ${pamixer} -i 2";
         XF86AudioLowerVolume = "exec ${pamixer} -d 2";
         XF86AudioMute = "exec ${pamixer} -t";

         # Media controls
         XF86AudioStop = "exec ${player} stop";
         XF86AudioPrev = "exec ${player} previous";
         XF86AudioPlay = "exec ${player} play-pause";
         XF86AudioNext = "exec ${player} next";

         Print = "exec wayshot -c -s \"`slurp -f '%x %y %w %h'`\" --stdout | wl-copy -t image/png";

         # Brightness control
         XF86MonBrightnessUp   = "exec light -A 5";
         XF86MonBrightnessDown = "exec light -U 5";

         # Window Navigation
         "${modifier}+h" = "focus left";
         "${modifier}+j" = "focus down";
         "${modifier}+k" = "focus up";
         "${modifier}+l" = "focus right";
         "${modifier}+u" = "focus mode_toggle";

         # Workspace Navigation (positional)
         "${modifier}+z" = "workspace 1";
         "${modifier}+x" = "workspace 2";
         "${modifier}+c" = "workspace 3";
         "${modifier}+v" = "workspace 4";
         "${modifier}+b" = "workspace 5";
         # Workspace Navigation (relative)
         "${modifier}+bracketright" = "workspace next";
         "${modifier}+bracketleft" = "workspace prev";
         # Window Management
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

         # This is used similar to the axis lines on a coordinate plane,
         # up arrow, right arrow = positive = increases size
         # down arrow, left arrow = negative = decreases size
         "${modifier}+left" = "resize shrink width 5";
         "${modifier}+right" = "resize grow width 5";
         "${modifier}+up" = "resize grow height 5";
         "${modifier}+down" = "resize shrink height 5";
      };
    };
  };
}
