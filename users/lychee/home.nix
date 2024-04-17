{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge optionals;
  is = osConfig.hey.caps;
in {
  home.packages =
    [pkgs.ripgrep]
    ++ optionals is.graphical (builtins.attrValues {
      inherit
        (pkgs)
        anki
        ;
      discord = pkgs.vesktop;
    });
}
