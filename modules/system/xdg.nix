{ pkgs, config, ...}:
with pkgs.lib;
{
  config.xdg.portal = {
    enable = mkDefault true;
    wlr.enable = mkDefault true;
    # this option seems to be messing up Firefox's GTK filechooser,
    # so I'm disabling this for now.
    #
    # gtkUsePortal = mkDefault true;
    extraPortals = mkOrder 999 (with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ]);
  };
}
