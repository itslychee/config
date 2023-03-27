{ pkgs, config, ...}:
with pkgs.lib;
{
  config.fonts = {
    fontDir.enable =  true;
    fonts = with pkgs; [
      ubuntu_font_family
      spleen
      dejavu_fonts
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk
      noto-fonts-emoji
      tamsyn
      liberation_ttf
      font-awesome
      material-design-icons
      terminus_font
      corefonts
      (nerdfonts.override { fonts = [
        "FiraCode"
        "Iosevka"
        "SourceCodePro"
        "JetBrainsMono"
      ]; })
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
