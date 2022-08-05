{ pkgs, ... }:
{
  wayland.windowManager.sway.config = rec {
    modifier = "Mod4";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    keybindings = let
      pamixer = "${pkgs.pamixer}/bin/pamixer";
      player = "${pkgs.playerctl}/bin/playerctl";
      light = "${pkgs.brightnessctl}/bin/brightnessctl";
    in {
      "${modifier}+space"     = "exec ${terminal} --class=launcher -e sway-launcher-desktop";
      "${modifier}+shift+t"   = "exec ${terminal}";
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

      # Brightness control
      XF86MonBrightnessUp   = "exec ${light} s 5%+";
      XF86MonBrightnessDown = "exec ${light} s 5%-";

      "${modifier}+q" = "exec ${pkgs.flameshot}/bin/flameshot gui";

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
      "${modifier}+shift+delete" = "exec ${pkgs.swaylock}/bin/swaylock --ring-color ffa9d2 -c 29101a --key-hl-color FFFFFF --inside-color 29101a";

    };
  };
}
