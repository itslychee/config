{
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  inherit (lib) mkForce flatten;
  inherit (lib.fileset) toList;
in
{
  imports = flatten [
    (toList ../../modules)
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
  services.fail2ban.enable = false;
  services.openssh.openFirewall = true;

  programs.starship.enable = mkForce false;

  # for nixos-anywhere
  environment.systemPackages = [ pkgs.rsync ];
}
