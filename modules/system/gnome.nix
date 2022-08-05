{ config, pkgs, ...}:
{
    config.services.gnome.gnome-keyring.enable = pkgs.lib.mkDefault true;
}
