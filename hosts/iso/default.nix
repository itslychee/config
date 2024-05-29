{
  lib,
  modulesPath,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
in {
  imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel.nix")];

  isoImage.isoBaseName = mkForce "configuration";
  networking.networkmanager.enable = true;
  networking.wireless.enable = mkForce false;

  services.kmscon.autologinUser = "lychee";
  hey.users.lychee.usePasswdFile = mkForce false;
  services.tailscale.enable = mkForce false;
  hey.net.fail2ban = mkForce false;
  hey.caps = {
    rootLogin = true;
    headless = true;
  };

  # for nixos-anywhere
  environment.systemPackages = [pkgs.rsync];
}
