{
  pkgs,
  lib,
  config,
  ...
}: {
  fonts = lib.mkIf config.hey.caps.graphical {
    enableDefaultPackages = true;
    packages = builtins.attrValues {
      inherit
        (pkgs)
        terminus_font
        noto-fonts-cjk
        source-code-pro
        noto-fonts-emoji
        material-design-icons
        dejavu_fonts
        liberation_ttf
        font-awesome
        ;
      nerdfonts = pkgs.nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"
          "JetBrainsMono"
        ];
      };
    };
    fontconfig.defaultFonts = {
      monospace = ["Terminus" "JetBrains Nerd Font Mono" "Source Code Pro"];
      emoji = ["Noto Color Emoji" "Font Awesome 6 Free"];
      serif = ["DejaVu Serif"];
      sansSerif = ["DejaVu Sans"];
    };
  };
}
