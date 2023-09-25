{ config, pkgs, flags, inputs, ...}:
with pkgs.lib;
{
  imports = [
    (import ../mixins/home/crypt.nix {})
    ./programs.nix
    ./services.nix
    ./graphical.nix
    ./firefox.nix
    ./waybar.nix
  ];

  # Git
  programs.git.ignores = [
    "*.swp"
    ".envrc"
    ".direnv"
  ];

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop   = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download  = "${config.home.homeDirectory}/downloads";
      music     = "${config.home.homeDirectory}/media/music";
      videos    = "${config.home.homeDirectory}/media/videos";
      pictures  = "${config.home.homeDirectory}/media/images";
      templates = "${config.home.homeDirectory}/media/templates";
      publicShare = "${config.home.homeDirectory}/pub";
    };
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };
  home.packages = with pkgs; [
    # System info tool
    neofetch
  ]
  # MPD applications
  ++ optionals config.services.mpd.enable [ mpc-cli ]

  # Non-headless specific packages (desktop)
  ++ optionals (!flags.headless or false) [
    libreoffice
    vscode
    discord
    wayshot
    slurp
    grim
    wl-clipboard
    gimp-with-plugins
  ]

  # Headless specific packages (server) 
  ++ optionals (flags.headless or false) [];
}
