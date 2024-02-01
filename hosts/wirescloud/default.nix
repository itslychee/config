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
  networking.firewall.allowedTCPPorts = [80 443];

  programs.zsh.enable = true;

  hey.sshServer.enable = true;
  users.users = {
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
