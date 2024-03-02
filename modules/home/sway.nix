{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkOption
    mkIf
    mapAttrsToList
    concatStringsSep
    mkEnableOption
    ;
  inherit
    (lib.types)
    attrsOf
    nullOr
    str
    lines
    ;
  cfg = config.wms.sway;
in {
  options.wms.sway = {
    enable = mkEnableOption "Sway";
    keybindings = mkOption {
      type = attrsOf (nullOr str);
      apply = f: let
        pamixer = lib.getExe pkgs.pamixer;
        player = "${lib.getExe pkgs.playerctl} --player='spotify,mpd,%any'";
        _ = lib.getExe;
        modifier = "Mod4";
        wayshot = "${_ pkgs.wayshot} -s \"$(${_ pkgs.slurp})\" --stdout";
      in
        {
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
        }
        // f;
      default = {};
    };
    extraConfig = mkOption {
      type = lines;
      default = "";
      apply = f:
        lib.concatStringsSep "\n" [
          f
          "exec_always ${lib.getExe pkgs.autotiling-rs}"
        ];
    };
  };

  config = mkIf cfg.enable {
    switches.opengl = true;
    root.".config/sway/config".text =
      (
        concatStringsSep "\n"
        (
          mapAttrsToList (k: v: "bindsym ${k} ${v}")
          (lib.filterAttrs (_: v: v != null) cfg.keybindings)
        )
      )
      + cfg.extraConfig;

    packages = [pkgs.swayfx pkgs.wl-clipboard];
  };
}
