# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{config, ...}: {
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hey = {
    caps.headless = true;
    net.home = true;
    users.lychee.sshKeys = config.hey.keys.users.lychee.local_ssh;
  };

  services.logind.lidSwitchExternalPower = "ignore";
  system.stateVersion = "23.11"; # Did you read the comment?
}
