{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
  cfg = config.hey.users;
  inherit (lib) mkIf;
in {
  age.secrets.lychee-password.file = "${inputs.self}/secrets/lychee-password.age";
  users.users.lychee = mkIf cfg.lychee.enable {
    isNormalUser = true;
    openssh.authorizedKeys.keys = config.hey.keys.users.lychee;
    extraGroups = ["wheel"];
    hashedPasswordFile = config.age.secrets.lychee-password.path;
  };
  hey.users.lychee = {
    wms.sway = {
      extraConfig = ''
        exec_always ${lib.getExe pkgs.autotiling-rs}
      '';
      keybindings = let
        _ = getExe;
        pamixer = getExe pkgs.pamixer;
        player = "${getExe pkgs.playerctl} --player='spotify,mpd,%any'";
        modifier = "Mod4";
        wayshot = "${_ pkgs.wayshot} -s \"$(${_ pkgs.slurp})\" --stdout";
      in {
        Print = "exec ${wayshot} | wl-copy";
        "Shift+Print" = "exec ${wayshot} | ${_ pkgs.swappy} -f - -o - | wl-copy";
        XF86AudioRaiseVolume = "exec ${pamixer} -i 2";
        XF86AudioLowerVolume = "exec ${pamixer} -d 2";
        XF86AudioMute = "exec ${pamixer} -t";
        XF86AudioStop = "exec ${player} stop";
        XF86AudioPrev = "exec ${player} previous";
        XF86AudioPlay = "exec ${player} play-pause";
        XF86AudioNext = "exec ${player} next";
        XF86MonBrightnessUp = "exec ${_ pkgs.light} -A 5";
        XF86MonBrightnessDown = "exec ${_ pkgs.light} -U 5";
        "${modifier}+Return" = "exec ${_ pkgs.alacritty}";
        "${modifier}+Space" = "exec ${_ pkgs.fuzzel}";
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
  };
}
