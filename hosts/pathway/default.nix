# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICE5cYKkvfT55xxhmLirU6K+JAHaZNd0xCsXPYrTuAEu";
    caps.headless = true;
    caps.graphical = true;
    net.home = true;
    users.lychee.enable = lib.mkForce false;
    users.viewer = {
      enable = true;
    };
  };

  services.kmscon.enable = lib.mkForce false;
  services.greetd.enable = lib.mkForce false;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      Autologin = {
        User = "viewer";
        Session = "plasma-bigscreen-x11.desktop";
        Relogin = true;
      };
    };
    theme = "chili";
  };
  environment.systemPackages = [pkgs.sddm-chili-theme];

  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5 = {
    bigscreen.enable = true;
  };
  services.logind.lidSwitchExternalPower = "ignore";
  system.stateVersion = "23.11"; # Did you read the comment?
}
