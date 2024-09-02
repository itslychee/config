{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mapAttrs filterAttrs;
  inherit (lib.types) submodule attrsOf listOf package str nullOr bool;
  inherit (lib.fileset) toList fileFilter;
  cfg = filterAttrs (_k: v: v.enable) config.hey.users;
in {
  options.hey.users = mkOption {
    description = "Hey user management";
    type = attrsOf (submodule (_: {
      options = {
        enable = mkEnableOption "Enable management of user";
        packages = mkOption {
          type = listOf package;
          default = [];
          description = "user packages";
        };
        groups = mkOption {
          type = listOf str;
          default = [];
          description = "user groups";
        };
        usePasswdFile = mkOption {
          type = bool;
          default = true;
        };
        passwordFile = mkOption {
          type = nullOr str;
          description = "Path to hashed password";
          default = null;
        };
        sshKeys = mkOption {
          type = listOf str;
          description = "SSH Keys for OpenSSH";
          default = [];
        };
      };
    }));
  };

  config = {
    users.users =
      mapAttrs (_name: value: {
        inherit (value) packages;
        isNormalUser = true;
        hashedPasswordFile = value.passwordFile;
        extraGroups = value.groups;
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = value.sshKeys;
      })
      cfg;
  };
}
