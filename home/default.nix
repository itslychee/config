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
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/media/music";
      videos = "${config.home.homeDirectory}/media/videos";
      pictures = "${config.home.homeDirectory}/media/images";
      templates = "${config.home.homeDirectory}/media/templates";
      publicShare = "${config.home.homeDirectory}/pub";
    };
  };
  home.packages = with pkgs; [ ]
    # Headless & Non-headless appliations
    ++ [ neofetch nmap zip unzip gnutar]
    # MPD applications
    ++ optionals config.services.mpd.enable [ mpc-cli mpdrp ]
    # Non-headless specific packages (desktop)
    ++ optionals (!flags.headless or false) [
    libreoffice
    vscode
    wayshot
    discord
    slurp
    grim
    wl-clipboard
    gimp-with-plugins
    kcolorchooser
    nixpkgs-fmt
    python3Full
    python3.pkgs.pip
  ]
    # Headless specific packages (server) 
    ++ optionals (flags.headless or false) [ ];
}
