{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib.types) attrsOf submodule;
  inherit (lib.fileset) toList fileFilter;
  inherit
    (lib)
    any
    flatten
    filterAttrs
    mkOption
    mkForce
    mapAttrs'
    mapAttrsToList
    nameValuePair
    ;

  eachUser = u:
    mapAttrs' (name: value:
      nameValuePair name {
        inherit (value) packages;
      }) (filterAttrs (n: v: v.enable) u);

  eachFile = u:
    mapAttrs' (name: value:
      nameValuePair name {
        rules =
          mapAttrsToList (
            filename: f: "L+ %h/${filename} - - - - ${f.source}"
          )
          value.root;
      }) (filterAttrs (n: v: v.enable) u);

  switch = f: mkForce (any f (flatten (attrValues config.hey.users)));
in {
  options = {
    hey.users = mkOption {
      type = attrsOf (submodule {
        imports = flatten [
          {_module.args = {inherit pkgs inputs;};}
          (toList (fileFilter (file: file.hasExt "nix") ./home))
        ];
      });
      description = "User-specific options";
    };
  };
  config = {
    users.users = eachUser config.hey.users;
    systemd.user.tmpfiles.users = eachFile config.hey.users;
    # switches
    hardware.opengl.enable = switch (u: u.switches.opengl);
    programs.light.enable = switch (u: u.switches.light);
  };
}
