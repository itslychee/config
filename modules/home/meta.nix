{lib, ...}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) submodule listOf nullOr attrsOf path str bool package;
  fileType = submodule ({
    name,
    config,
    ...
  }: {
    options = {
      source = mkOption {
        type = nullOr path;
        default = null;
      };
      text = mkOption {
        type = nullOr str;
        default = null;
      };
      executable = mkOption {
        type = bool;
        default = false;
      };
    };
  });
in {
  options = {
    enable = mkEnableOption "User";
    root = mkOption {
      type = attrsOf fileType;
      default = {};
    };
    packages = mkOption {
      type = listOf package;
      default = [];
    };
    # switches are for home -> system translations
    switches.opengl = mkEnableOption "OpenGL System Support";
    switches.light = mkEnableOption "Brightness udev rules";
  };
}
