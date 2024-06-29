{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.sessionVariables = {
    XDG_DESKTOP_DIR = "$HOME/desktop";
    XDG_DOCUMENTS_DIR = "$HOME/documents";
    XDG_DOWNLOAD_DIR = "$HOME/downloads";
    XDG_MUSIC_DIR = "$HOME/media/music";
    XDG_PICTURES_DIR = "$HOME/media/pictures";
    XDG_PUBLICSHARE_DIR = "$HOME/media/public";
    XDG_TEMPLATES_DIR = "$HOME/media/templates";
    XDG_VIDEOS_DIR = "$HOME/media/videos";
  };

  xdg.portal = lib.mkIf config.hey.caps.graphical {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-kde pkgs.xdg-desktop-portal-gtk];
  };
}
