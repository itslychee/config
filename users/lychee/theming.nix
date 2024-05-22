{
  inputs,
  config,
  pkgs,
  ...
}: let
  sway = config.wayland.windowManager.sway.enable;
  spicePkgs = inputs.spice.legacyPackages.${pkgs.stdenv.system};
in {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.spice.homeManagerModules.default
  ];

  catppuccin.flavor = "macchiato";
  services.mako = {
    borderColor = "#f7cde4";
    backgroundColor = "#543245";
    layer = "overlay";
  };

  home.pointerCursor = {
    name = "OpenZone";
    package = pkgs.openzone-cursors;
    gtk.enable = config.gtk.enable;
  };
  gtk = {
    enable = true;
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
  qt.enable = true;
  xdg.enable = true;

  programs.spicetify = {
    enable = true;
    enabledExtensions = builtins.attrValues {
      inherit
        (spicePkgs.extensions)
        adblock
        autoVolume
        copyToClipboard
        history
        hidePodcasts
        ;
    };
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };
}
