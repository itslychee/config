{
  inputs,
  config,
  pkgs,
  ...
}: let
  sway = config.wayland.windowManager.sway.enable;
in {
  imports = [inputs.catppuccin.homeManagerModules.catppuccin];

  catppuccin.flavour = "macchiato";
  services.mako = {
    borderColor = "#f7cde4";
    backgroundColor = "#543245";
    layer = "overlay";
  };

  home.pointerCursor = {
    name = "OpenZone";
    package = pkgs.openzone-cursors;
    gtk.enable = sway;
  };
  gtk = {
    enable = sway;
    catppuccin.enable = true;
    font = {
      name = "DejaVu Sans";
      package = pkgs.dejavu_fonts;
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus Light";
    };
  };
  qt.enable = sway;
  xdg.enable = sway;
}
