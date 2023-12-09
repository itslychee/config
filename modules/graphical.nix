_: {
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkMerge
    mkEnableOption
    mkOption
    ;
  inherit (lib.types) submodule;
  inherit (config.hey) gui;
in {
  options.hey.gui = mkOption {
    type = submodule ({config, ...}: {
      options = {
        sound = mkEnableOption "PipeWire";
        fonts = mkEnableOption "Default fonts";
        all = mkEnableOption "Enable all GUI options";
      };
      config = mkIf config.all {
        sound = true;
        fonts = true;
      };
    });
  };

  config = mkMerge [
    # Sound
    (mkIf gui.sound {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    })
    # Fonts
    (mkIf gui.fonts {
      fonts.packages = [
        # TODO: Add fonts
        # NOTE: DO NOT OVERPOPULATE THIS FIELD MORE THAN NECESSARY
      ];
      fonts.enableDefaultPackages = true;
    })
  ];
}
