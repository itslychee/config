{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce mkDefault;
in {
  # System capabilities, for finer control and context
  options.hey.caps = {
    # OpenGL, GUI-related stuff, must I explain further?? >:(
    graphical = mkEnableOption "graphical capabilities";
    # SSH daemon, fail2ban, anything a server should have
    headless = mkEnableOption "headless capabilities";
  };

  config = {
    # Global options
    time.timeZone = mkDefault "US/Central";

    boot.loader.systemd-boot.configurationLimit = 10;
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) dnsutils;
      inherit (inputs.self.packages.${pkgs.stdenv.system}) nvim;
    };

    environment.pathsToLink = ["/share"];
    documentation.nixos.enable = mkForce false;
    hardware.enableAllFirmware = true;
    programs.command-not-found.enable = false;
    boot.blacklistedKernelModules = [
      "uvcvideo"
    ];
    environment.etc."xdg/user-dirs.defaults".text = ''
      XDG_DESKTOP_DIR="$HOME/desktop"
      XDG_DOCUMENTS_DIR="$HOME/documents"
      XDG_DOWNLOAD_DIR="$HOME/downloads"
      XDG_MUSIC_DIR="$HOME/media/music"
      XDG_PICTURES_DIR="$HOME/media/pictures"
      XDG_PUBLICSHARE_DIR="$HOME/public"
      XDG_TEMPLATES_DIR="$HOME/media/templates"
      XDG_VIDEOS_DIR="$HOME/media/videos"
    '';
  };
}
