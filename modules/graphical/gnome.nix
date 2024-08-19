{
  lib,
  pkgs,
  config,
  ...
}: {
  services.gnome = lib.mkForce {
    gnome-keyring.enable = false;
    tracker.enable = false;
  };
}
