# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{...}: {
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICE5cYKkvfT55xxhmLirU6K+JAHaZNd0xCsXPYrTuAEu";
    caps.headless = true;
  };

  services.logind.lidSwitchExternalPower = "ignore";
  system.stateVersion = "23.11"; # Did you read the comment?
}
