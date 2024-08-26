{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkForce mkDefault;
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

    boot.loader.systemd-boot.configurationLimit = 5;
    boot.loader.timeout = mkDefault 1;
    environment.systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        htop
        ripgrep
        dnsutils
        jq
        nmap
        gnupg
        ;
    };

    environment.pathsToLink = ["/share"];
    documentation.nixos.enable = mkForce false;
    programs.command-not-found.enable = false;
    boot.blacklistedKernelModules = [
      "uvcvideo"
    ];
    hardware.enableRedistributableFirmware = mkDefault true;
    hardware.enableAllFirmware = mkDefault true;

    # Better pager :3
    environment.sessionVariables.PAGER = lib.getExe pkgs.moar;

    programs.gnupg.agent = {
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };
}
