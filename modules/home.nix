{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mapAttrs filterAttrs;
  inherit (lib.types) submodule attrsOf listOf package str nullOr;
  inherit (lib.fileset) toList fileFilter;
  cfg = filterAttrs (k: v: v.enable) config.hey.users;
in {
  imports = [
    inputs.home-manager.nixosModules.default
  ];
  options.hey.users = mkOption {
    description = "Hey user management";
    type = attrsOf (submodule ({name, ...}: {
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
        usePasswdFile = mkEnableOption "use hashed password file";
        passwordFile = mkOption {
          type = nullOr str;
          description = "Path to hashed password";
          default = null;
        };
        sshKeys = mkOption {
          type = listOf str;
          description = "Public SSH Keys for OpenSSH Server";
        };

        state = mkOption {
          type = nullOr str;
          default = null;
          description = "Home Manager state version";
        };

        wms.sway = {
          enable = mkEnableOption "Sway";
          outputs = mkOption {
            type = attrsOf (attrsOf str);
            default = {};
          };
        };
      };
    }));
  };

  config = {
    systemd.user.tmpfiles.rules = [
      "f %h/.zshrc - - - -"
    ];
    home-manager = {
      backupFileExtension = "backup";
      extraSpecialArgs = {
        inherit inputs;
      };
      useGlobalPkgs = true;
      useUserPackages = true;
      users =
        mapAttrs (
          name: value: {
            imports = toList (fileFilter (file: file.hasExt "nix") ../users/${name});

            home.stateVersion = value.state;
            wayland.windowManager.sway = {
              inherit (value.wms.sway) enable;
              config.output = value.wms.sway.outputs;
            };
          }
        )
        (filterAttrs (name: value: value.state != null)
          cfg);
    };
    users.users =
      mapAttrs (name: value: {
        inherit (value) packages;
        isNormalUser = true;
        hashedPasswordFile = value.passwordFile;
        extraGroups = value.groups;
        openssh.authorizedKeys.keys = value.sshKeys;
        shell = pkgs.zsh;
      })
      cfg;
  };
}
