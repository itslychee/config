{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe getExe';
in {
  hey.users.lychee.wms.sway = {
    keybindings = let
      _ = getExe;
      __ = getExe';
      player = "${_ pkgs.playerctl} --player='spotify,mpd,%any'";
      modifier = "Mod4";
      wayshot = "${_ pkgs.wayshot} -s \"$(${_ pkgs.slurp})\" --stdout";
    in {
      Print = "exec ${wayshot} | wl-copy";
      "Shift+Print" = "exec ${wayshot} | ${_ pkgs.swappy} -f - -o - | wl-copy";
      "Control+Print" = "exec ${_ pkgs.wl-screenrec} -g \"`${_ pkgs.slurp}`\" -f ~/media/screenshots/\"`date +'%F_%H.%H_%M_%N'`\".mp4";
      "Control+Delete" = "exec ${__ pkgs.procps "pkill"} wl-screenrec";
      XF86AudioRaiseVolume = "exec ${_ pkgs.pamixer} -i 2";
      XF86AudioLowerVolume = "exec ${_ pkgs.pamixer} -d 2";
      XF86AudioMute = "exec ${_ pkgs.pamixer} -t";
      XF86AudioStop = "exec ${player} stop";
      XF86AudioPrev = "exec ${player} previous";
      XF86AudioPlay = "exec ${player} play-pause";
      XF86AudioNext = "exec ${player} next";
      XF86MonBrightnessUp = "exec ${_ pkgs.light} -A 5";
      XF86MonBrightnessDown = "exec ${_ pkgs.light} -U 5";
      "${modifier}+Return" = pkgs.alacritty;
      "${modifier}+Space" = pkgs.fuzzel;
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
    autostart = [
      pkgs.autotiling-rs
      "${getExe pkgs.swaybg} -m fill -i ~/.wallpaper-image"
    ];
    extraConfig = ''
      workspace 1
      default_dim_inactive 0.3
      default_border pixel 3

      #                 <border>    <bg>     <text>   <indicator>  <child_border>
      client.focused   '#FF9AD2' '#523645' '#debdcf' '#FF9AD2'     '#FF9AD2'
      client.unfocused '#401f31' '#523645' '#855f74' '#401f31'     '#401f31'
    '';
  };
}
