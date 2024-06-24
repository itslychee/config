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
    programs.command-not-found.enable = false;
    boot.blacklistedKernelModules = [
      "uvcvideo"
    ];
  };
}
