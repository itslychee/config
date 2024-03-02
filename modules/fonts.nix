{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkAfter mkEnableOption;
in {
  options.hey.fonts = {
    enable = mkEnableOption "Font management";
  };
  config.fonts = mkIf config.hey.fonts.enable {
    fontDir.enable = true;
    packages = mkAfter (builtins.attrValues {
      inherit
        (pkgs)
        terminus_font
        noto-fonts-cjk
        source-code-pro
        noto-fonts-emoji
        dejavu_fonts
        ;
    });
    fontconfig.defaultFonts = {
      monospace = ["Terminus" "Source Code Pro"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
