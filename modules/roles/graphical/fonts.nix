{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = builtins.attrValues {
      inherit (pkgs)
        terminus_font
        noto-fonts-cjk-sans
        source-code-pro
        noto-fonts-emoji
        material-design-icons
        dejavu_fonts
        liberation_ttf
        font-awesome
        ;
      inherit (pkgs.nerd-fonts) symbols-only jetbrains-mono;
    };
    fontconfig.defaultFonts = {
      monospace = [
        "Terminus"
        "JetBrains Nerd Font Mono"
        "Source Code Pro"
      ];
      emoji = [
        "Font Awesome 6 Free"
        "Noto Color Emoji"
        "Material Design Icons"
      ];
      serif = [ "DejaVu Serif" ];
      sansSerif = [ "DejaVu Sans" ];
    };
  };
}
