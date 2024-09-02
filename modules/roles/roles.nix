{lib, ...}: {
  options.hey.roles = {
    graphical = lib.mkEnableOption "Graphical";
    server = lib.mkEnableOption "Headless";
  };
}
