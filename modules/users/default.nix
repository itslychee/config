_: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkOption
    evalModules
    foldl'
    mapAttrsToList
    recursiveUpdate
    mkMerge
    optional
    ;
  inherit
    (lib.types)
    bool
    raw
    attrsOf
    submoduleWith
    submodule
    nameValuePair
    ;
  userOption = {config, ...}: {
    options = {
      privileged = mkOption {
        type = bool;
        description = "Whether or not if the user should have root-privileges";
      };
      config = mkOption {
        type = raw;
        description = "Home configuration";
      };
    };
  };
  homeConf =
    mapAttrsToList (name: value: let
      home = evalModules {
        specialArgs = {inherit pkgs;};
        modules = [
          ./home-module.nix
          value.config
        ];
      };
    in {
      users.users.${name} = {
        createHome = true;
        isNormalUser = true;
        inherit (home.config.home) packages;
      };

      # User-specific files
      systemd.user.tmpfiles.users.${name}.rules = map (
          v: "L+ %h/${v.target} - - - - ${v.source}"
        ) optional (home.home ? files) home.home.files;
    })
    config.hey.users;
in {
  options.hey.users = mkOption {
    type = attrsOf (submodule userOption);
    description = "User management";
  };
  config = {
    systemd = mkMerge (map (d: d.systemd) homeConf);
    users = mkMerge (map (d: d.users) homeConf);
  };
}
