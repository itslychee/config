{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cfg = config.hey.ctx;
  inherit (lib) mkOption mkEnableOption mkIf mapAttrs' mapAttrsToList nameValuePair;
  inherit (lib.types) attrsOf listOf nullOr package submodule path str bool;

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
  eachUser = u:
    mapAttrs' (name: value:
      nameValuePair name {
        inherit (value) packages;
      }) (lib.filterAttrs (n: v: v.enable) u);

  eachFile = u:
    mapAttrs' (name: value:
      nameValuePair name {
        rules =
          mapAttrsToList (
            filename: f: let
              file =
                if f.text != null
                then
                  pkgs.writeTextFile {
                    name = "${filename}-tmpfile";
                    inherit (f) text executable;
                  }
                else f.source;
            in "L+ %h/${name} - - - - ${file}"
          )
          value.root;
      }) (lib.filterAttrs (n: v: v.enable) u);
in {
  options = {
    hey.users = mkOption {
      type = attrsOf (submodule ({config, ...}: {
        imports = [
          {_module.args = {inherit pkgs inputs;};}
          ./home
        ];
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
        };
      }));
      description = "User-specific options";
      default = {};
    };
  };
  config.assertions = [
    {
      assertion = lib.all (b: b) (lib.flatten (
        lib.forEach
        (builtins.attrValues config.hey.users)
        (user: map (x: (x.source == null && x.text != null) || (x.source != null && x.text == null)) (builtins.attrValues user.root))
      ));
      message = "file(s) cannot have both .text and .source set";
    }
  ];

  config.users.users = eachUser config.hey.users;
  config.systemd.user.tmpfiles.users = eachFile config.hey.users;
}
