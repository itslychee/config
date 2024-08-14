{
  osConfig,
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (lib) getExe;
  cfg = config.wayland.windowManager.sway;
in {
  wayland.windowManager.sway = {
    package = pkgs.swayfx;
    checkConfig = false; # fixes the dumb build time check
    config = {
      bars = [];
      window.commands = [
        {
          command = "floating enable";
          criteria.class = "xdg_shell";
        }
      ];
      colors =
        lib.genAttrs [
          "focused"
          "unfocused"
        ] (mode: let
          inherit (osConfig.hey) theme;
        in {
          inherit (theme) background;
          text = theme.foreground;
          border =
            if mode == "unfocused"
            then theme.accent
            else "#FF9AD2";
          childBorder =
            if mode == "unfocused"
            then theme.accent
            else "#FFFFFF";
          indicator = theme.accent;
        });
      gaps.smartBorders = "on";
      focus.followMouse = "no";
      modifier = "Mod4";
      terminal = pkgs.alacritty;
      menu = null;
      output."*".bg = "${../../assets/wallpaper} fill";

      keybindings = let
        pamixer = "${pkgs.pamixer}/bin/pamixer";
        player = "${pkgs.playerctl}/bin/playerctl --player='spotify,mpd,%any'";
        inherit (cfg.config) modifier;
      in {
        Print = ''
          exec wayshot -c -s "`slurp -f '%x %y %w %h'`" --stdout | wl-copy -t image/png'';
        "Shift+Print" = ''
          exec wayshot -c -s "`slurp -f '%x %y %w %h'`" --stdout | swappy -f - -o - | wl-copy -t image/png'';
        XF86AudioRaiseVolume = "exec ${pamixer} -i 2";
        XF86AudioLowerVolume = "exec ${pamixer} -d 2";
        "${modifier}+Shift+Backspace" = "exec ${pkgs.systemd}/bin/systemctl poweroff -i";
        XF86AudioMute = "exec ${pamixer} -t";
        XF86AudioStop = "exec ${player} stop";
        XF86AudioPrev = "exec ${player} previous";
        XF86AudioPlay = "exec ${player} play-pause";
        XF86AudioNext = "exec ${player} next";
        XF86MonBrightnessUp = "exec light -A 5";
        XF86MonBrightnessDown = "exec light -U 5";
        "Alt+Tab" = "exec ${lib.getExe config.programs.rofi.package} -show window";
        "${modifier}+Return" = "exec ${lib.getExe pkgs.alacritty}";
        "${modifier}+Space" = "exec ${lib.getExe config.programs.rofi.package} -show drun";
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
    };
    extraConfig = ''
      exec ${getExe pkgs.autotiling-rs}
      exec ${getExe inputs.soteria.packages.${pkgs.system}.default}
      workspace number 1
      default_border pixel 2
    '';
  };
}
