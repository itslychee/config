{
  inputs,
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
