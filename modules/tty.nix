{
  pkgs,
  lib,
  config,
  ...
}: {
  services.kmscon = {
    enable = lib.mkDefault config.hey.caps.graphical;
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
      {
        name = "Material Design Icons";
        package = pkgs.material-design-icons;
      }
    ];
  };
}
