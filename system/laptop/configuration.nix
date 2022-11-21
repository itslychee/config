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
    ../../modules/system/gnome.nix
    ../../modules/system/swaylock.nix
    ../../modules/system/brightness.nix
  ];


  # Custom kernel parameters
  boot.kernelParams = [
    "noacpi"
  ];
  hardware.bluetooth.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";

  networking = {
    hostName = "laptop";
    interfaces = {
      wlp0s12f0.useDHCP = true;
    };
  };
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ nodejs ];

  users.users = {
    lychee = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "audio"];
    };
  };
  system.stateVersion = "21.11";
}

