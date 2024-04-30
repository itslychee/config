{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optionals;
  is = osConfig.hey.caps;
in {
  home.packages =
    [pkgs.ripgrep]
    ++ optionals is.graphical (builtins.attrValues {
      inherit
        (pkgs)
        anki
        ;
      #discord = pkgs.discord-canary.override {withVencord = true;};
      discord = pkgs.vesktop;
    });
}
