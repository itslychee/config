{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkAfter mkEnableOption mkMerge;
in {
  options.hey = {
    graphical.enable = mkEnableOption "Graphical";
    fonts.enable = mkEnableOption "Font management";
    pipewire.enable = mkEnableOption "PipeWire";
  };

  config = mkMerge [
    (mkIf config.hey.graphical.enable {
      hey.fonts.enable = true;
      hey.pipewire.enable = true;
    })
    (mkIf config.hey.fonts.enable {
      fonts = {
        fontDir.enable = true;
        packages = mkAfter (builtins.attrValues {
          inherit
            (pkgs)
            terminus_font
            noto-fonts-cjk
            source-code-pro
            noto-fonts-emoji
            dejavu_fonts
            liberation_ttf
            ;
          nerdfonts = pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];};
        });
        fontconfig.defaultFonts = {
          monospace = ["Terminus" "Source Code Pro"];
          emoji = ["Noto Color Emoji"];
        };
      };
    })
    (mkIf config.hey.pipewire.enable {
      services.pipewire = {
        enable = true;
        pulse.enable = true;
        jack.enable = true;
        alsa.enable = true;
      };
      security.rtkit.enable = true;
    })
  ];
}
