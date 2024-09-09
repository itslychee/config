{lib, ...}: let
  dirs = {
    XDG_DESKTOP_DIR = "$HOME/desktop";
    XDG_DOCUMENTS_DIR = "$HOME/documents";
    XDG_DOWNLOAD_DIR = "$HOME/downloads";
    XDG_MUSIC_DIR = "$HOME/media/music";
    XDG_PICTURES_DIR = "$HOME/media/pictures";
    XDG_PUBLICSHARE_DIR = "$HOME/media/public";
    XDG_TEMPLATES_DIR = "$HOME/media/templates";
    XDG_VIDEOS_DIR = "$HOME/media/videos";
  };
in {
  environment.etc."xdg/user-dirs.default".text = ''
    XDG_DESKTOP_DIR = "desktop";
    XDG_DOCUMENTS_DIR = "doc";
    XDG_DOWNLOAD = "downloads";
    XDG_MUSIC = "music";
    XDG_PICTURES = "media/pictures";
    XDG_PUBLICSHARE = "media/public";
    XDG_TEMPLATES = "media/templates";
    XDG_VIDEOS = "media/videos";
  '';
  environment.etc."xdg/user-dirs.conf".text = ''
    enabled=False
  '';
}
