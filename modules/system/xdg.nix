{ pkgs, config, ...}:
with pkgs.lib;
{
  config.xdg.portal = {
    enable = mkDefault true;
    wlr.enable = mkDefault true;
    gtkUsePortal = mkDefault true;
    extraPortals = mkDefault (with pkgs; [
      xdg-desktop-portal-gtk
    ]);
  };
}
