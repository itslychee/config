{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./agenix.nix
    ./caddy-module-patch.nix
    ./graphical.nix
    ./networking.nix
    ./home.nix
    ./keys.nix
    ./kmscon.nix
    ./matrix.nix
    ./nix.nix
    ./vaultwarden.nix
    ./website.nix
    "${inputs.self}/users/lychee"
  ];
  # Global options
  time.timeZone = "US/Central";
  security.polkit.enable = true;

  environment.defaultPackages = [pkgs.git];
  environment.etc."xdg/user-dirs.default".text = ''
    XDG_DESKTOP_DIR="$HOME/desktop"
    XDG_DOCUMENTS_DIR="$HOME/documents"
    XDG_DOWNLOAD_DIR="$HOME/downloads"
    XDG_MUSIC_DIR="$HOME/media/music"
    XDG_PICTURES_DIR="$HOME/media/pictures"
    XDG_PUBLICSHARE_DIR="$HOME/public"
    XDG_TEMPLATES_DIR="$HOME/media/templates"
    XDG_VIDEOS_DIR="$HOME/media/videos"
  '';

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };
}
