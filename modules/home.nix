{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cfg = config.hey.ctx;
  inherit
    (lib)
    mkOption
    mkIf
    mapAttrs'
    mapAttrsToList
    nameValuePair
    ;
  inherit
    (lib.types)
    attrsOf
    listOf
    nullOr
    package
    submodule
    path
    str
    bool
    ;

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

  userType = submodule ({config, ...}: {
    imports = [
      {_module.args = {inherit pkgs inputs;};}
      ./home
    ];
    options = {
      root = mkOption { type = attrsOf fileType; default = {}; };
      packages = mkOption { type = listOf package; default = []; };
    };
  });
in {
  options = {
    hey.users = mkOption {
      type = attrsOf userType;
      description = "User-specific options";
      default = {};
    };
  };
  config = {
    assertions = [
      {
        assertion = lib.all (b: b) (lib.flatten (
          lib.forEach
          (builtins.attrValues config.hey.users)
          (user: map (x: (x.source == null && x.text != null) || (x.source != null && x.text == null)) (builtins.attrValues user.root))
        ));
        message = "file(s) cannot have both .text and .source set";
      }
    ];

    # Packages
    users.users = mapAttrs' (name: value: {inherit name; value.packages = value.packages;}) config.hey.users;
    # File management
    systemd.user.tmpfiles.users =
      mapAttrs' (
        k: v:
          nameValuePair k
          {
            rules =
              mapAttrsToList (
                name: value: let
                  file =
                    if value.text != null
                    then
                      pkgs.writeTextFile {
                        name = "${k}-${name}-tmpfile";
                        inherit (value) text executable;
                      }
                    else value.source;
                in "L+ %h/${name} - - - - ${file}"
              )
              v.root;
          }
      ) config.hey.users;
    hardware.opengl.enable = mkIf (builtins.elem cfg.platform [ "hybrid" "client" ]) true;
  };


}
