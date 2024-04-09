{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.hey.users.lychee;
  inherit (lib) mkIf;
in {
  age.secrets.lychee-password.file = "${inputs.self}/secrets/lychee-password.age";
  # should be obvious why this is global
  hey.users.lychee = {
    enable = true;
    sshKeys = config.hey.keys.users.lychee.ssh;
    passwordFile = config.age.secrets.lychee-password.path;
    groups = [
      "wheel"
      "audio"
      "video" # needed for light
      "networkmanager"
    ];
  };
}
