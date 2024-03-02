{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mapAttrs' mapAttrsToList nameValuePair;
  inherit (lib.types) attrsOf submodule;
  inherit (lib) any flatten all;

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
            in "L+ %h/${filename} - - - - ${file}"
          )
          value.root;
      }) (lib.filterAttrs (n: v: v.enable) u);

  switch = f: lib.mkForce (any f (flatten (builtins.attrValues config.hey.users)));
in {
  options = {
    hey.users = mkOption {
      type = attrsOf (submodule ({config, ...}: {
        imports = [
          {_module.args = {inherit pkgs inputs;};}
          ./home
        ];
      }));
      description = "User-specific options";
    };
  };
  config.assertions = [
    {
      assertion = all (b: b) (flatten (
        lib.forEach
        (builtins.attrValues config.hey.users)
        (user: map (x: (x.source == null && x.text != null) || (x.source != null && x.text == null)) (builtins.attrValues user.root))
      ));
      message = "file(s) cannot have both .text and .source set";
    }
  ];

  config = {
    users.users = eachUser config.hey.users;
    systemd.user.tmpfiles.users = eachFile config.hey.users;
    # switches
    hardware.opengl.enable = switch (u: u.switches.opengl);
  };
}
