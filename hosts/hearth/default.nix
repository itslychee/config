{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./rtw_fix.nix
    ./mpd.nix
  ];

  boot = {
    kernelParams = ["irqpoll"];
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  hey = {
    caps = {
      graphical = true;
      headless = true;
    };
    net.home = true;
    users.lychee = {
      enable = true;
      wms.sway.enable = true;
      packages = [
        pkgs.firefox
        pkgs.xdg-utils
        pkgs.qbittorrent
        (pkgs.discord-canary.override {
          withVencord = true;
          withOpenASAR = true;
        })
      ];
    };
  };
  networking.firewall = {
      allowedTCPPorts = [1113];
      allowedUDPPorts = [1113];
  };

  hardware = {
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
  };


  environment.systemPackages = [pkgs.bluez-tools];

  users.users.lychee = {
      openssh.authorizedKeys.keys = config.hey.keys.users.lychee.local_ssh;
      extraGroups = [ "audio" ];
  };

  # SSD trimming
  services.fstrim.enable = true;

  # nix-index
  environment.sessionVariables.NIX_INDEX_DATABASE = "/var/lib/nix-index-db";
  programs.nix-index.enable = true;

  # do not touch ever! #
  system.stateVersion = "24.05";
}
