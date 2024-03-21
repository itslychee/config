{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkAfter mkOption getExe;
  inherit (lib.types) bool;
in {
  options.hey.graphical = {
    enable = mkOption {
      type = bool;
      default = config.hey.caps.graphical;
    };
  };

  config = mkIf config.hey.graphical.enable {
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
            "--cmd \"${getExe pkgs.cage} -s ${getExe pkgs.swayfx}\""
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
      kmscon = {
        enable = true;
        hwRender = true;
        fonts = [
          {
            name = "Terminus";
            package = pkgs.terminus_font;
          }
          {
            name = "NerdFontsSymbolsOnly";
            package = pkgs.nerdfonts.override {
              fonts = [
                "NerdFontsSymbolsOnly"
              ];
            };
          }
        ];
      };
    };
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = true;
      config.sway.default = ["wlr" "gtk"];
    };
  };
}
