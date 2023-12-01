{ config, pkgs, lib, headless, ...}:
{
  imports = [
    ./nvim
    ./shell
    ./dev.nix
  ] 
  ++ lib.optionals (!headless) [
    ./graphical.nix
    ./sway.nix
    ./mpd.nix
    ./waybar.nix
    ./firefox.nix
  ] 
  ++ lib.optionals headless [];

  # XDG
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    desktop     = "${config.home.homeDirectory}/desktop";
    documents   = "${config.home.homeDirectory}/documents";
    download    = "${config.home.homeDirectory}/downloads";
    music       = "${config.home.homeDirectory}/media/music";
    videos      = "${config.home.homeDirectory}/media/videos";
    pictures    = "${config.home.homeDirectory}/media/images";
    templates   = "${config.home.homeDirectory}/media/templates";
    publicShare = "${config.home.homeDirectory}/pub";
  };

  home.packages = with pkgs;
  [
    zip unzip gnutar gzip
  ] ++
  lib.optionals (!headless) [
    # Discord
    (discord-canary.override {
      withOpenASAR = true;
      withVencord = true;
      withTTS = true;
    }) 
    xdg-utils
    # Screenshot
    slurp wayshot swappy
    # Clipboard
    wl-clipboard
    # spotify
    unstable.spotify
  ];
}
