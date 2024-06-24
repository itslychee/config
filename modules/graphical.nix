{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkAfter
    getExe
    ;
in {
  config = mkIf config.hey.caps.graphical {
    programs.light.enable = true;
    programs.dconf.enable = true;
    fonts = {
      fontDir.enable = true;
      packages = mkAfter (builtins.attrValues {
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
      });
      fontconfig.defaultFonts = {
        monospace = ["Terminus" "JetBrains Nerd Font Mono" "Source Code Pro"];
        emoji = ["Noto Color Emoji" "Font Awesome 6 Free"];
        serif = ["Terminus"];
        sansSerif = ["Terminus"];
      };
    };

    security.rtkit.enable = true;

    services = {
      greetd = {
        enable = true;
        settings.default_session = {
          command = lib.concatStringsSep " " [
            (getExe pkgs.greetd.tuigreet)
            "--cmd ${getExe pkgs.swayfx}"
            "--asterisks"
            "--time"
          ];
        };
      };
      pipewire = {
        enable = true;
        pulse.enable = true;
        jack.enable = true;
        alsa.enable = true;
      };
    };
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      configPackages = [pkgs.xdg-desktop-portal-gtk];
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };
}
