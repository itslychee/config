{ lib, modulesPath, mylib, config, ... }:
let
  inherit (lib) mkForce;
in {
  imports = [ (modulesPath +"/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix") ];
  networking.networkmanager.enable = true;
  networking.wireless.enable = mkForce false;
  hey.services.openssh.enable = true;
  users.users = {
     root.openssh.authorizedKeys.keys = mylib.keys.privileged config.hey.keys.users.lychee;
  };
}
