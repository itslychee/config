{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkForce mkDefault;
in
{
  # Global options
  time.timeZone = mkDefault "US/Central";

  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.timeout = mkDefault 1;

  documentation.nixos.enable = mkForce false;
  programs.command-not-found.enable = false;
  boot.tmp.cleanOnBoot = true;
  environment.systemPackages = [
    pkgs.nmap
    pkgs.htop
    pkgs.traceroute
    pkgs.tmux
  ];

  environment.pathsToLink = [ "/share" ];
}
