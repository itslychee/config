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

  services.kmscon.autologinUser = "lychee";
  hey.users.lychee = {
      state = "24.05";
      passwordFile = mkForce null;
  };
  hey.caps = {
    rootLogin = true;
    headless = true;
  };

  documentation = {
    enable = mkForce false;
    info.enable = mkForce false;
    dev.enable = mkForce false;
    doc.enable = mkForce false;
    nixos.enable = mkForce false;
  };


  # for nixos-anywhere
  environment.systemPackages = [pkgs.rsync];
}
