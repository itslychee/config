{
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  inherit (lib) mkForce flatten;
in {
  imports = flatten [
    ../../modules/keys.nix
    ../../modules/security/known_hosts.nix
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
  ];

  boot.kernelPackages = mkForce ();
  isoImage.isoBaseName = mkForce "ISOLATED_ISO";

  environment.defaultPackages = mkForce [];

  networking = {
    hostName = "ISOLATEDISO";
    useDHCP = mkForce false;
    # not needed if networking doesn't exist :3
    dhcpcd.enable = mkForce false;
    firewall.enable = mkForce false;
  };

  users.users.staging = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  security = {
    protectKernelImage = mkForce true;
    lockKernelModules = mkForce true;
    polkit.enable = mkForce false;
    wrappers.su.setuid = mkForce false;
    wrappers.su.passwd = mkForce false;
  };
}
