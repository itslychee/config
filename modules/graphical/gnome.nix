{
  lib,
  pkgs,
  config,
  ...
}:
with lib.gvariant; {
  services.gnome = lib.mkForce {
    gnome-keyring.enable = false;
    tracker.enable = false;
  };

  environment.systemPackages = [
    pkgs.gnomeExtensions.dash-to-panel
    pkgs.gnomeExtensions.appindicator
  ];

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/Console" = {
          custom-font = "Terminus 10";
          font-scale = mkDouble "0.9";
          last-window-maximised = true;
          last-window-size = mkTuple [(mkInt32 1452) (mkInt32 890)];
          use-system-font = false;
        };
        "org/gnome/Totem" = {
          active-plugins = ["skipto" "recent" "screenshot" "rotation" "movie-properties" "apple-trailers" "screensaver" "autoload-subtitles" "open-directory" "mpris" "variable-rate" "vimeo" "save-file"];
          subtitle-encoding = "UTF-8";
        };

        "org/gnome/control-center" = {
          last-panel = "mouse";
          window-state = mkTuple [(mkInt32 1327) (mkInt32 630) false];
        };

        "org/gnome/desktop/app-folders" = {
          folder-children = ["Utilities" "YaST" "Pardus"];
        };

        "org/gnome/desktop/app-folders/folders/Pardus" = {
          categories = ["X-Pardus-Apps"];
          name = "X-Pardus-Apps.directory";
          translate = true;
        };

        "org/gnome/desktop/app-folders/folders/Utilities" = {
          apps = ["gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop"];
          categories = ["X-GNOME-Utilities"];
          name = "X-GNOME-Utilities.directory";
          translate = true;
        };

        "org/gnome/desktop/app-folders/folders/YaST" = {
          categories = ["X-SuSE-YaST"];
          name = "suse-yast.directory";
          translate = true;
        };
        "org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-timeout = mkInt32 0;

        "org/gnome/desktop/background" = {
          color-shading-type = "solid";
          picture-options = "zoom";
          picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
          picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
          primary-color = "#241f31";
          secondary-color = "#000000";
        };

        "org/gnome/desktop/input-sources" = {
          sources = [(mkTuple ["xkb" "us"])];
          xkb-options = ["terminate:ctrl_alt_bksp"];
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "default";
          gtk-enable-primary-paste = false;
          icon-theme = "Adwaita";
        };

        "org/gnome/desktop/notifications" = {
          application-children = ["firefox" "spotify" "org-gnome-console" "gnome-power-panel" "org-rncbc-qpwgraph" "steam" "org-gnome-characters"];
        };

        "org/gnome/desktop/notifications/application/firefox" = {
          application-id = "firefox.desktop";
        };

        "org/gnome/desktop/notifications/application/gnome-power-panel" = {
          application-id = "gnome-power-panel.desktop";
        };

        "org/gnome/desktop/notifications/application/org-gnome-characters" = {
          application-id = "org.gnome.Characters.desktop";
        };

        "org/gnome/desktop/notifications/application/org-gnome-console" = {
          application-id = "org.gnome.Console.desktop";
        };

        "org/gnome/desktop/notifications/application/org-rncbc-qpwgraph" = {
          application-id = "org.rncbc.qpwgraph.desktop";
        };

        "org/gnome/desktop/notifications/application/spotify" = {
          application-id = "spotify.desktop";
        };

        "org/gnome/desktop/notifications/application/steam" = {
          application-id = "steam.desktop";
        };

        "org/gnome/desktop/peripherals/mouse" = {
          natural-scroll = false;
          speed = mkDouble "0.1";
        };

        "org/gnome/desktop/peripherals/touchpad" = {
          two-finger-scrolling-enabled = true;
        };

        "org/gnome/desktop/privacy" = {
          old-files-age = mkUint32 (mkInt32 30);
          recent-files-max-age = mkInt32 (-1);
        };

        "org/gnome/desktop/search-providers" = {
          sort-order = ["org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop"];
        };

        "org/gnome/desktop/session" = {
          idle-delay = mkUint32 (mkInt32 300);
        };

        "org/gnome/desktop/sound" = {
          event-sounds = true;
          theme-name = "__custom";
        };

        "org/gnome/desktop/wm/keybindings" = {
          move-to-workspace-1 = ["<Shift><Super>z"];
          move-to-workspace-2 = ["<Shift><Super>x"];
          move-to-workspace-3 = ["<Shift><Super>c"];
          move-to-workspace-4 = ["<Shift><Super>v"];
          move-to-workspace-5 = ["<Super><Shift>b"];
          switch-to-workspace-1 = ["<Super>z"];
          switch-to-workspace-2 = ["<Super>x"];
          switch-to-workspace-3 = ["<Super>c"];
          switch-to-workspace-4 = ["<Super>v"];
          switch-to-workspace-5 = ["<Super>b"];
        };

        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
          num-workspaces = mkInt32 5;
        };

        "org/gnome/epiphany" = {
          ask-for-default = false;
        };

        "org/gnome/epiphany/state" = {
          is-maximized = false;
          window-size = mkTuple [(mkInt32 1024) (mkInt32 768)];
        };

        "org/gnome/evolution-data-server" = {
          migrated = true;
        };

        "org/gnome/maps" = {
          last-viewed-location = [(mkDouble "0.0") (mkDouble "0.0")];
          map-type = "MapsStreetSource";
          transportation-type = "pedestrian";
          window-maximized = true;
          window-size = [(mkInt32 1097) (mkInt32 420)];
          zoom-level = mkInt32 2;
        };

        "org/gnome/mutter" = {
          edge-tiling = true;
          workspaces-only-on-primary = false;
        };

        "org/gnome/nautilus/icon-view" = {
          default-zoom-level = "medium";
        };

        "org/gnome/nautilus/list-view" = {
          default-zoom-level = "small";
        };

        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "list-view";
          migrated-gtk-settings = true;
          search-filter-time-type = "last_modified";
        };

        "org/gnome/nautilus/window-state" = {
          initial-size = mkTuple [(mkInt32 890) (mkInt32 550)];
          maximized = false;
        };

        "org/gnome/shell/extensions/dash-to-panel" = {
          animate-appicon-hover = true;
          animate-appicon-hover-animation-extent = [
            (mkDictionaryEntry "RIPPLE" (mkInt32 2))
            (mkDictionaryEntry "PLANK" (mkInt32 4))
            (mkDictionaryEntry "SIMPLE" (mkInt32 1))
          ];
          animate-appicon-hover-animation-rotation = [
            (mkDictionaryEntry "SIMPLE" (mkInt32 0))
            (mkDictionaryEntry "RIPPLE" (mkInt32 5))
            (mkDictionaryEntry "PLANK" (mkInt32 0))
          ];
          animate-appicon-hover-animation-type = "RIPPLE";
          appicon-margin = mkInt32 2;
          appicon-padding = mkInt32 4;
          appicon-style = "NORMAL";
          available-monitors = [(mkInt32 0)];
          dot-position = "BOTTOM";
          hotkeys-overlay-combo = "TEMPORARILY";
          isolate-workspaces = false;
          leftbox-padding = mkInt32 (-1);
          panel-anchors = ''
            {"0":"MIDDLE"}
          '';
          panel-element-positions = ''
            {"0":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedTL"},{"element":"rightBox","visible":true,"position":"stackedTL"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"activitiesButton","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}
          '';
          panel-lengths = ''
            {"0":100}
          '';
          panel-positions = ''
            {"0":"BOTTOM"}
          '';
          panel-sizes = ''
            {"0":32}
          '';
          primary-monitor = mkInt32 0;
          show-apps-icon-file = "";
          status-icon-padding = mkInt32 (-1);
          trans-bg-color = "#673131";
          trans-panel-opacity = mkDouble "0.5";
          trans-use-custom-bg = false;
          trans-use-custom-opacity = true;
          trans-use-dynamic-opacity = true;
          tray-padding = mkInt32 (-1);
          window-preview-title-position = "TOP";
        };

        "org/gnome/shell/extensions/window-list" = {
          display-all-workspaces = false;
          grouping-mode = "always";
        };

        "org/gnome/tweaks" = {
          show-extensions-notice = false;
        };

        "org/gtk/gtk4/settings/color-chooser" = {
          custom-colors = [(mkTuple [(mkDouble "0.4033333361148834") (mkDouble "0.19360001385211945") (mkDouble "0.19360001385211945") (mkDouble "1.0")]) (mkTuple [(mkDouble "1.0") (mkDouble "0.6039215922355652") (mkDouble "0.8235295414924622") (mkDouble "1.0")])];
          selected-color = mkTuple [true (mkDouble "0.4033333361148834") (mkDouble "0.19360001385211945") (mkDouble "0.19360001385211945") (mkDouble "1.0")];
        };

        "org/gtk/gtk4/settings/file-chooser" = {
          date-format = "regular";
          location-mode = "path-bar";
          show-hidden = false;
          sidebar-width = mkInt32 140;
          sort-column = "name";
          sort-directories-first = true;
          sort-order = "ascending";
          type-format = "category";
          view-type = "list";
          window-size = mkTuple [(mkInt32 859) (mkInt32 372)];
        };

        "org/gtk/settings/file-chooser" = {
          date-format = "regular";
          location-mode = "path-bar";
          show-hidden = false;
          show-size-column = true;
          show-type-column = true;
          sidebar-width = mkInt32 157;
          sort-column = "name";
          sort-directories-first = false;
          sort-order = "ascending";
          type-format = "category";
          window-position = mkTuple [(mkInt32 26) (mkInt32 23)];
          window-size = mkTuple [(mkInt32 1094) (mkInt32 842)];
        };
      };
    }
  ];
}
