{ config, pkgs, ... }:
{
  imports = [
    ../../modules/system/pipewire.nix
    ../../modules/system/opengl.nix
    ../../modules/system/fonts.nix
    ../../modules/system/systemd-boot.nix
    ../../modules/system/xdg.nix
    ../../modules/system/networkmanager.nix
    ../../modules/system/gpg-agent.nix
  ];


  # Custom kernel parameters
  boot.kernelParams = [
    "noacpi"
    "acpi=strict"
  ];

  boot.loader.systemd-boot.consoleMode = "max";

  networking = {
    hostName = "laptop";
    interfaces = {
      wlp0s12f0.useDHCP = true;
    };
  };
  programs.fish.enable = true;
  programs.dconf.enable = true;

  services.fwupd.enable = true;

  users.users = {
    lychee = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
  system.stateVersion = "21.11";
}

