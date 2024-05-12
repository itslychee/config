{
  lib,
  modulesPath,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
in {
  imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel.nix")];
  networking.networkmanager.enable = true;
  networking.wireless.enable = mkForce false;

  services.kmscon.autologinUser = "lychee";
  hey.users.lychee.usePasswdFile = mkForce false;
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
