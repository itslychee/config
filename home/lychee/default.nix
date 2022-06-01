{ pkgs, config, ...}:
{
  imports = [
    ./alacritty.nix
    ./sway.nix
    ./neovim.nix
    ./browser.nix
    ./shell.nix
    ./gui.nix
    ./overlays
  ];

  home = {
    stateVersion = "22.05";
    pointerCursor = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 16;
      gtk.enable = true;
      x11.enable = true;
    };
    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DBUS_REMOTE = "1";
      _JAVA_ART_WM_NONREPARENTING = "1";
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland-egl";
      GDK_BACKEND = "wayland";
      SDL_VIDEODRIVER= "wayland";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
    };
    sessionPath = [ "~/go/bin" ];
    packages = with pkgs; [
      tree
      nix-tree
      gcolor3
      curl
      neofetch
      wl-clipboard
      (symlinkJoin {
        name = "launcher-but-better";
        paths = [
          sway-launcher-desktop
          (writeShellScriptBin "launcher" ''
            HIST_FILE="" sway-launcher-desktop
          '')
        ];
      })
    ];
  };

  programs = {
    bash = {
      # Let HM manage my configuration
      enable = true;
      enableVteIntegration = true;
    };
    htop = {
      enable = true;
      settings = {
        color_scheme = 5;
        tree_view = 1;
        tree_view_always_by_pid = 1;
        enable_mouse = 1;
        degree_fahrenheit = 1;
        delay = 10;
      };
    };
    git = rec {
      enable = true;
      userName = "Lychee";
      userEmail = "itslychee@protonmail.com";
      signing = {
        signByDefault = true;
        key = userEmail;
      };
    };
    ssh = {
      enable = true;
      compression = true;
      matchBlocks = {
        "Raspberry Pi" = {
          host = "pi";
          hostname = "192.168.0.3";
          user = "pi";
        };
        "Personal PC" = {
          host = "desktop";
          hostname = "192.168.0.2";
          user = "lychee";
        };
    };
  };
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
  };
}
