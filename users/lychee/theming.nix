{
  inputs,
  config,
  pkgs,
  ...
}: let
  spicePkgs = inputs.spice.legacyPackages.${pkgs.stdenv.system};
in {
  imports = [
    inputs.spice.homeManagerModules.default
  ];

  services.mako = {
    borderColor = "#f7cde4";
    backgroundColor = "#543245";
    layer = "overlay";
  };

  home.pointerCursor = {
    name = "OpenZone_Black";
    package = pkgs.openzone-cursors;
    gtk.enable = config.gtk.enable;
  };
  gtk = {
    enable = true;
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
