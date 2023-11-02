{ config, pkgs, flags, inputs, ... }:
with pkgs.lib;
{
  imports = [
    (import ../mixins/home/crypt.nix {
      git = {
        enable = true;
        userName = "Lychee";
        userEmail = "itslychee@protonmail.com";
        withDelta = true;
      };
    })
    ./programs.nix
    ./services.nix
    ./graphical.nix
    ./firefox.nix
    ./waybar.nix
    ./neovim.nix
    ./shell.nix
  ];
  # Git
  programs.git.ignores = [ "*.swp" ".envrc" ".direnv" ];
  xdg = {
    userDirs = let
      dir = config.home.homeDirectory;
    in {
      enable = true;
      createDirectories = true;
      desktop     = "${dir}/desktop";
      documents   = "${dir}/documents";
      download    = "${dir}/downloads";
      music       = "${dir}/media/music";
      videos      = "${dir}/media/videos";
      pictures    = "${dir}/media/images";
      templates   = "${dir}/media/templates";
      publicShare = "${dir}/pub";
    };
  };

  home.packages = with pkgs; [ ]
    # Headless & Non-headless appliations
    ++ [
      neofetch
      nmap
      zip unzip gnutar
      (python310.withPackages(p: with p; [ ipython pip ]))
      ruff
    ]
    # MPD applications
    ++ optionals config.services.mpd.enable [ mpc-cli ]
    # Non-headless specific packages (desktop)
    ++ optionals (!flags.headless or false) [
    wayshot
    spotify
    slurp
    discord
    grim
    wl-clipboard
    gimp-with-plugins
    kcolorchooser
    xdg-utils
  ]
    # Headless specific packages (server) 
    ++ optionals (flags.headless or false) [ ];
}
