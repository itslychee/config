{ pkgs, config, hostname, ...}@inputs:
rec {
  imports = [
    ./alacritty.nix
    ./sway.nix
    ./neovim.nix
    ./browser.nix
    ./shell.nix
    ./gui.nix
    ./mpd.nix
    ./waybar.nix
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
      GDK_BACKEND = "wayland";
      SDL_VIDEODRIVER= "wayland";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
    };
    sessionPath = [ "~/go/bin" ];
    packages = with pkgs; [
      tree
      nheko
      nix-tree
      gcolor3
      curl
      neofetch
      upower
      wl-clipboard
      brightnessctl
      unzip
      appimage-run
      playerctl
      mpc-cli
      spotify
      swaylock
      gimp
      pamixer
      geeqie
      nix-alien
      nix-index
      nix-index-update
      obsidian
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

  programs = {
   gpg.enable = true;
   bash.enable = true;
   direnv = {
     enable = true;
     nix-direnv.enable = true;
     stdlib = ''
        : ''${XDG_CACHE_HOME:=$HOME/.cache}
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
              local path="''${PWD//[^a-zA-Z0-9]/-}"  
              echo "$XDG_CACHE_HOME/direnv/layouts/''${path:1}"
            )}"
        }
     '';
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
      delta = {
        enable = true;
        options = {
          line-numbers = true;
        };
      };
      extraConfig = {
        core.editor = home.sessionVariables.EDITOR;
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
    mako = {
      enable = true;
      anchor = "top-right";
      backgroundColor = "#764a5f";
      borderColor = "#915b75";
      borderRadius = 2;
      defaultTimeout = 7000;
      font = "Source Code Pro 10";
      format = "<b>%a</b>\\n%s\\n%b";
    };
    exa = {
      enable = true;
      enableAliases = true;
    };
  };

  systemd.user.services.mako = pkgs.lib.mkIf config.programs.mako.enable {
    Service.ExecStart = "${pkgs.mako}/bin/mako";
    Service.Restart = "on-failure";
    Unit.Requires = [ "sway-session.target" ];
    Install.RequiredBy = [ "sway-session.target" ];
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
