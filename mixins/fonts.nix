{ pkgs, config, ...}:
with pkgs.lib;
{
  config.fonts = {
    fontDir.enable =  true;
    fonts = with pkgs; [
      jetbrains-mono
      ubuntu_font_family
      spleen
      dejavu_fonts
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk
      noto-fonts-emoji
      tamsyn
      terminus_font
      liberation_ttf
      font-awesome
      fira
      source-code-pro
      iosevka-bin
      material-design-icons
      corefonts
    ];
    enableDefaultFonts =  true;
    fontconfig.defaultFonts = {
      emoji =  [ "Noto Color Emoji" ];
      monospace =  [
        "Iosevka"
        "Terminus"
        "Fira Mono"
      ];
      serif =  [ "DejaVu Serif" ];
      sansSerif =  [ "Fira Sans" ];
    }; 
  };
}
