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
      package = pkgs.fira;
      name = "Fira Sans";
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
  # Qt Theming
  qt = {
    enable = true;
    style = {
      package = pkgs.arc-kde-theme;
      name = "Arc Dark";
    };
  };
}

