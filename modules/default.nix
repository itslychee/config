{
  # Global options
  time.timeZone = "US/Central";

  environment.etc."xdg/user-dirs.default".text = ''
    XDG_DESKTOP_DIR="$HOME/desktop"
    XDG_DOCUMENTS_DIR="$HOME/documents"
    XDG_DOWNLOAD_DIR="$HOME/downloads"
    XDG_MUSIC_DIR="$HOME/media/music"
    XDG_PICTURES_DIR="$HOME/media/pictures"
    XDG_PUBLICSHARE_DIR="$HOME/public"
    XDG_TEMPLATES_DIR="$HOME/media/templates"
    XDG_VIDEOS_DIR="$HOME/media/videos"
  '';
}
