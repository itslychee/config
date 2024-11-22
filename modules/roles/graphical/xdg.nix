{ ... }:
{
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
