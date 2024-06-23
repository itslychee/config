{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkForce;
in {
  boot = {
    kernelParams = ["irqpoll"];
    kernelPackages = pkgs.linuxKernel.packages.linux_6_9;
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOaAxiB8BtVJC+3WM/ydH+8CRaINbE+7X3aO1l/0cJhV";
    caps = {
      graphical = true;
      headless = true;
    };
    users.lychee = {
      state = "24.05";
      groups = ["docker"];
      sshKeys = config.hey.keys.lychee.local_ssh;
      packages = [
        pkgs.ciscoPacketTracer8
        pkgs.alacritty
      ];
    };
  };

  services.greetd.enable = mkForce false;
  services.kmscon.enable = mkForce false;

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      sddm-chili-theme
      libreoffice
      ;
  };
  environment.plasma6.excludePackages = builtins.attrValues {
    inherit
      (pkgs.kdePackages)
      elisa
      konsole
      kate
      kwrited
      ;
  };
  services.displayManager.sddm = {
    enable = true;
    theme = "chili";
    wayland.enable = true;
  };

  services.desktopManager.plasma6 = {
    enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [1113];
    allowedUDPPorts = [1113];
  };

  hardware = {
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
  };

  services.fstrim.enable = true;

  programs = {
    nix-index.enable = true;
    virt-manager.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
  };

  environment.sessionVariables.NIX_INDEX_DATABASE = "/var/lib/nix-index-db";
  # do not touch ever! #
  system.stateVersion = "24.05";
}
