{
  config,
  inputs,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    ./secrets.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;

  hey.sshServer.enable = true;

  hey.services = {
    matrix = {
      enable = true;
      serverName = "lefishe.club";
      matrixHostname = "matrix.lefishe.club";
    };
    vault = {
      enable = true;
      domain = "vault.lefishe.club";
    };
    website = {
      enable = true;
      domain = "lefishe.club";
    };
  };
  users.users = {
    root.openssh.authorizedKeys.keys = config.hey.keys.users.lychee;
    lychee = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = config.hey.keys.users.lychee;
      extraGroups = ["wheel"];
      hashedPasswordFile = config.age.secrets.lychee-password.path;
    };
  };




  # do not change
  system.stateVersion = "23.05";
}
