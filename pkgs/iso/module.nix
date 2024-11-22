{
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  inherit (lib) mkForce flatten;
  inherit (lib.fileset) toList difference;
in
{
  imports = flatten [
    (toList (difference ../../modules ../../modules/roles))
    ../../modules/roles/roles.nix
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
  ];
  networking.hostName = "iso";
  boot.kernelModules = [
    # Support LVM
    "dm-snapshot"
    "dm-mod"
    "dm-cache"
    "dm-cache-default"
  ];

  networking.wireless.enable = mkForce false;
  isoImage.isoBaseName = mkForce "configuration";

  services.kmscon.autologinUser = "lychee";
  services.fail2ban.enable = lib.mkForce false;
  services.openssh.openFirewall = lib.mkForce true;

  programs.starship.enable = mkForce false;

  # for nixos-anywhere
  environment.systemPackages = [ pkgs.rsync ];
}
