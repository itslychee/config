{
  lib,
  config,
  mylib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  # System capabilities, for finer control and context
  options.hey.caps = {
    # OpenGL, GUI-related stuff, must I explain further?? >:(
    graphical = mkEnableOption "graphical capabilities";
    # SSH daemon, fail2ban, anything a server should have
    headless = mkEnableOption "headless capabilities";
    # Will be used locally, servers should not use this.
    rootLogin = mkEnableOption "root SSH login capabilities";
  };

  config = {
    users.users.root = mkIf config.hey.caps.rootLogin {
      openssh.authorizedKeys.keys = mylib.keys.all config.hey.keys.users.lychee;
    };
    # Global options
    time.timeZone = "US/Central";

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

    boot.loader.systemd-boot.configurationLimit = 10;
    environment.systemPackages = [ pkgs.deploy-rs ];
  };
}
