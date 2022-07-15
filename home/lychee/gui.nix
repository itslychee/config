{ pkgs, config, ...}:
{
  # GTK Theming
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.luna-icons;
      name = "Luna-Dark";
    };
    font = {
      package = pkgs.noto-fonts;
      name = "Noto Sans Serif";
      size = 10;
    };
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    gtk3.bookmarks = [
      "file://${config.home.homeDirectory}/downloads"
      "file://${config.home.homeDirectory}/git"
    ];
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme=1;
      gtk-enable-primary-paste=false;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme=1;
      gtk-enable-primary-paste=false;
    };
  };
}

