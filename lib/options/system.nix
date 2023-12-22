{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options = {
    # Options
    shell.zsh = mkEnableOption "Zsh shell";
    shell.fish = mkEnableOption "Fish shell";
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
    programs.fish.enable = config.shell.fish;
    environment.pathsToLink = mkIf config.shell.zsh ["/share/zsh"];
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
        dejavu_fonts
        ubuntu_font_family
        noto-fonts
        noto-fonts-emoji-blob-bin
        noto-fonts-cjk
        twemoji-color-font
        font-awesome
        material-design-icons
        corefonts
        liberation_ttf
        terminus_font
        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
            "SourceCodePro"
            "Iosevka"
            "NerdFontsSymbolsOnly"
          ];
        })
      ];
      enableDefaultPackages = true;
      fontconfig.defaultFonts = {
        emoji = [
          "Blobmoji"
          "Noto Color Emojis"
          "Material Design Icons"
          "Font Awesome 6 Free"
        ];
        monospace = ["Terminus" "JetBrains Nerd Font Mono" "Ubuntu Mono"];
        serif = ["DejaVu Serif" "Ubuntu"];
        sansSerif = ["DejaVu Sans" "Ubuntu"];
      };
    };
  };
}
