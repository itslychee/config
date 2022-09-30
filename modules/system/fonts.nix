{ pkgs, config, ...}:
with pkgs.lib;
{
  config.fonts = {
    fontDir.enable = mkDefault true;
    fonts = mkOrder 999 (with pkgs; [
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
	  nerdfonts
    ]);
    enableDefaultFonts = mkDefault true;
    fontconfig.defaultFonts = {
      emoji = mkDefault [ "Noto Color Emoji" ];
      monospace = mkDefault [
        "Iosevka"
        "Terminus"
        "Fira Mono"
      ];
      serif = mkDefault [ "DejaVu Serif" ];
      sansSerif = mkDefault [ "Fira Sans" ];
    }; 
  };
}
