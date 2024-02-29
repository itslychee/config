{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hey.users;
  inherit (lib) mkIf mkMerge;
in {
  age.secrets.lychee-password.file = "${inputs.self}/secrets/lychee-password.age";
  users.users.lychee = mkIf cfg.lychee.enable {
    isNormalUser = true;
    openssh.authorizedKeys.keys = config.hey.keys.users.lychee;
    extraGroups = ["wheel"];
    hashedPasswordFile = config.age.secrets.lychee-password.path;
  };
  hey.users.lychee = {
    packages = [];
  };
}
