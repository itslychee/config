{pkgs, ...}: {
  services.kmscon = {
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
}
