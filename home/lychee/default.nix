{ pkgs, config, hostname, ...}@inputs:
rec {
  imports = [
    ./alacritty.nix
    ./neovim.nix
    ./browser.nix
    ./shell.nix
    ./gui.nix
    ./mpd.nix
    ./utils.nix
    ./overlays
  ];

  home = {
    stateVersion = "22.11";
    pointerCursor = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 16;
      gtk.enable = true;
      x11.enable = true;
    };
    shellAliases = {
      "view" = "${pkgs.xdg-utils}/bin/xdg-open";
    };
    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DBUS_REMOTE = "1";
      _JAVA_ART_WM_NONREPARENTING = "1";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland";
      SDL_VIDEODRIVER= "wayland";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
    };
    sessionPath = [ "~/go/bin" ];
    packages = with pkgs; [
      # Media viewing
      imv
      mpv
      
      # Music controllers
      playerctl
      mpc-cli

      # Compression tools
      zstd
      gzip
      zip
      unzip

      tree
      gcolor3
      curl
      neofetch
      wl-clipboard
      gimp
      spotify
      swaylock
      pamixer
      rust-analyzer

      prismlauncher
      # Unstable packages
      unstable.bluetuith
      unstable.swaynotificationcenter
      (symlinkJoin {
        name = "sway-launcher-desktop";
        paths = [ sway-launcher-desktop ];
        buildInputs = [ makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/sway-launcher-desktop --set HIST_FILE ""
        '';
      })
    ]; 
  };
  xdg.configFile."swaync/config.json".text = ''
    {
      "notification-window-width": 420
    }
  '';
  programs.exa = {
      enable = true;
      enableAliases = true;
  };

  # Flameshot
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        uiColor = "#ffa9d2";
        showHelp = false;
        disabledTrayIcon = true;
     };
    }; 
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs = {
      documents = "$HOME/docs";
      desktop   = "$HOME/desktop";
      download  = "$HOME/downloads";
      music     = "$HOME/media/music";
      pictures  = "$HOME/media/images";
      videos    = "$HOME/media/videos";
    };
    desktopEntries.gimp.mimeType = [];
    desktopEntries.gimp.exec = "${pkgs.gimp}/bin/gimp %F";
    desktopEntries.gimp.name = "GNU Image Manipulation Program";
    
  };
}
