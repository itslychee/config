{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.hey.users;
  inherit (lib) mkIf;
in {
}
