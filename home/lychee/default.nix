{
  config,
  pkgs,
  lib,
  headless,
  ...
}: {
  imports =
    [./nvim ./shell ./dev.nix]
    ++ lib.optionals (!headless) [
      ./graphical.nix
      ./sway.nix
      ./music.nix
      ./waybar.nix
      ./firefox.nix
    ]
    ++ lib.optionals headless [];

  # XDG
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    desktop = "${config.home.homeDirectory}/desktop";
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/downloads";
    music = "${config.home.homeDirectory}/media/music";
    videos = "${config.home.homeDirectory}/media/videos";
    pictures = "${config.home.homeDirectory}/media/images";
    templates = "${config.home.homeDirectory}/media/templates";
    publicShare = "${config.home.homeDirectory}/pub";
  };

  home.packages = with pkgs;
    [zip unzip gnutar gzip nixpkgs-review]
    ++ lib.optionals (!headless) [
      # Discord
      (discord-canary.override {
        withOpenASAR = true;
        withVencord = true;
        withTTS = true;
      })
      xdg-utils
      qbittorrent
      # Screenshot
      slurp
      wayshot
      swappy
      # on the fly qmk_firmware configurer (bad english!??)
      via
      # Clipboard
      wl-clipboard
      # Cracked minecraft
      (pkgs.prismlauncher.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "Diegiwg";
          repo = "PrismLauncher-Cracked";
          rev = "01144ae9a1c8dc0036b7d218e948cce1ab79dac5";
          hash = "sha256-oE1dze+koAOOXWVYzJ5OAeUl9GwgAdx/vlAzJEBY5s4=";
        };
      })
    ];
}
