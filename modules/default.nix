{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;
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
      openssh.authorizedKeys.keys = config.hey.keys.users.lychee.ssh;
    };
    # Global options
    time.timeZone = "US/Central";

    boot.loader.systemd-boot.configurationLimit = 10;
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) dnsutils;
    };

    documentation.nixos.enable = mkForce false;
    hardware.enableAllFirmware = true;
    programs.command-not-found.enable = false;
    boot.blacklistedKernelModules = [
      "uvcvideo"
    ];
  };
}
