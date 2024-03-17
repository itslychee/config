{
  lib,
  modulesPath,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
in {
  imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix")];
  networking.networkmanager.enable = true;
  networking.wireless.enable = mkForce false;

  hey.caps = {
      rootLogin = true;
      headless = true;
  };

  # for nixos-anywhere
  environment.systemPackages = [pkgs.rsync];
}
