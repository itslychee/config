{ config, lib, pkgs, ...}:
let
  inherit (lib) mkIf mkEnableOption;
in  {
  options = {
    # Options
    shell.zsh = mkEnableOption "Zsh shell";
    system.sound = mkEnableOption "sound via PipeWire";
    graphical.enable = mkEnableOption "OpenGL";
    graphical.fonts.enable = mkEnableOption "manage fonts";
    graphical.fonts.defaults = mkEnableOption "install default fonts";
  };

  # Config
  config = {
    programs.bash.enableCompletion = true;
    # Zsh
    programs.zsh.enable = config.shell.zsh;
    environment.pathsToLink = mkIf config.shell.zsh [
      "/share/zsh"
    ];
    # Sound (PipeWire)
    services.pipewire = mkIf config.system.sound {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    # OpenGL
    hardware.opengl.enable = config.graphical.enable;

    # Fonts
    fonts = mkIf config.graphical.fonts.enable {
      fontDir.enable = true;
      packages = with pkgs; [
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
          (nerdfonts.override {
            fonts = [
              "FiraCode"
              "Iosevka"
              "SourceCodePro"
              "JetBrainsMono"
            ]; 
        })
      ];
      enableDefaultPackages = true;
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

  };
}
