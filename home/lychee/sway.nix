{ pkgs, lib, hostname, ...}@attrs:
{
  imports = [
    ./sway-keybindings.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraConfig = ''
      for_window {
        # Applications
        [app_id="^launcher$"] floating enable, sticky enable, resize set 30 ppt 60 ppt, border pixel 1
        [app_id="gcolor3"] floating enable, sticky enable, border pixel 0.5

        # File Dialogs
        [title="(?:Open|Save) (?:File|Folder|As)"] floating enable, resize set width 1030 height 710

        # Dolphin/Ark
        [title="^(File|Folder)\s*Already Exists\s*—\s*" app_id="dolphin|org.kde.ark"] floating enable
        [title="^(Copying|Moving)\s*—\s*Dolphin" app_id="dolphin"] inhibit_idle open; floating enable
        [title="^Extracting\s" app_id="(dolphin|org.kde.ark)"] inhibit_idle open; floating enable
        [title="^Information\s*—\s*Dolphin" app_id="dolphin"] floating enable
        [title="^Loading archive" app_id="org.kde.ark"] floating enable

        # Firefox
        [app_id="firefox" title="^Picture-in-Picture$"] floating enable; sticky enable
      }
      input "type:touchpad" {
        tap enabled
        scroll_method two_finger
      }
      input "type:keyboard" {
        dwt enabled
      }
    '';
    config = {
      window = {
        border = 2;
        titlebar = true;
      };
      fonts = {
        names = [ "Terminus" "Font Awesome 6 Free" ];
        style = "Regular";
        size = 9.0;
      };
      gaps = {
        outer = 6;
        inner = 5;
        smartBorders = "on";
        smartGaps = true;
      };
      defaultWorkspace = "workspace number 1";
      focus.followMouse = "no";
      colors.focused = rec {
          border = background;
          background = "#764a5f";
          text = "#e8e8e8";
          indicator = "#2e9ef4";
          childBorder = "#915b75";
      };
      output = import ./sway-outputs.nix { inherit hostname; };
    };
  };
}
