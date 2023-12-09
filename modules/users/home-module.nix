{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  options.home = {
    packages = mkOption {
      type = types.listOf types.package;
      description = "packages";
    };
    files = mkOption {
      type = types.listOf types.submodule {
        options = {
          source = mkOption {type = types.path;};
          target = mkOption {type = types.str;};
        };
      };
    };
  };
}
