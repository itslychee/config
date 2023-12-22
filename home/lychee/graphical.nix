{pkgs, ...}: {
  # Cursor
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 16;
    gtk.enable = true;
  };
  # GTK
  gtk.theme = {
    package = pkgs.yaru-remix-theme;
    name = "Yaru-remix-dark";
  };
  gtk.iconTheme = {
    package = pkgs.luna-icons;
    name = "Luna-Dark";
  };
  # GTK Config
  gtk.gtk2.extraConfig = "gtk-enable-primary-paste = false";
  gtk.gtk3.extraConfig = {gtk-enable-primary-paste = false;};
  gtk.gtk4.extraConfig = {gtk-enable-primary-paste = false;};
  # Dunst
  services.dunst.enable = true;
  services.dunst.settings = {
    global = {
      frame_color = "#ff99d2";
      sort = "no";
      offset = "10x20";
      frame_width = 1;
      padding = 6;
      font = "Terminus 10";
      gap_size = 2;
      format = ''
        <b>%a:</b><i>%s</i>
        %b'';
      show_indicators = false;
      browser = "${pkgs.xdg-utils}/bin/xdg-open";
      corner_radius = 5;
      width = 500;
      height = 800;
      stack_duplicates = false;
      history_length = 10;
    };
    urgency_normal = {
      background = "#4f5b82";
      timeout = "10s";
    };
  };
  xdg.configFile."swappy/config".text = ''
    [Default]
    show_panel = true
  '';
}
