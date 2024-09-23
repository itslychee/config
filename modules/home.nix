{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkMerge
    mkOption
    mkEnableOption
    mapAttrs
    filterAttrs
    flatten
    mapAttrsToList
    ;
  inherit (lib.types)
    submodule
    attrsOf
    listOf
    package
    str
    nullOr
    bool
    lines
    path
    ;
  inherit (lib.fileset) toList fileFilter;
  cfg = filterAttrs (_k: v: v.enable) config.hey.users;
in
{
  options.hey.users = mkOption {
    description = "Hey user management";
    type = attrsOf (
      submodule (_: {
        options = {
          enable = mkEnableOption "Enable management of user";
          packages = mkOption {
            type = listOf package;
            default = [ ];
            description = "user packages";
          };
          groups = mkOption {
            type = listOf str;
            default = [ ];
            description = "user groups";
          };
          hashedPassword = mkOption {
            type = nullOr str;
            description = "hashed password";
            default = null;
          };
          sshKeys = mkOption {
            type = listOf str;
            description = "SSH Keys for OpenSSH";
            default = [ ];
          };
          files = mkOption {
            description = "systemd.tmpfiles file management";
            default = { };
            type = attrsOf (
              submodule (
                { config, ... }:
                {
                  options = {
                    text = mkOption {
                      type = nullOr lines;
                      default = null;
                    };
                    source = mkOption {
                      type = nullOr path;
                      default = null;
                    };
                  };
                }
              )
            );
          };
        };
      })
    );
  };

  config = mkMerge [
    {
      users.users = mapAttrs (_name: value: {
        inherit (value) packages hashedPassword;
        isNormalUser = true;
        extraGroups = value.groups;
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = value.sshKeys;
      }) cfg;
    }
    {
      # Ensure option validity with files
      assertions = flatten (
        mapAttrsToList (
          username: value:
          mapAttrsToList (path: opts: {
            message = "${username}: ${path} has conflicting source & text definitions, please use only one";
            assertion =
              (opts.text != null && opts.source == null) || (opts.text == null && opts.source != null);
          }) value.files
        ) cfg
      );

      # Add the files
      systemd.user.tmpfiles.users = builtins.mapAttrs (name: options: {
        rules = mapAttrsToList (
          path: value:
          let
            source = if value.source != null then value.source else pkgs.writeText path value.text;
          in
          "L+ %h/${path} - - - - ${source}"
        ) options.files;
      }) cfg;
    }
  ];
}
