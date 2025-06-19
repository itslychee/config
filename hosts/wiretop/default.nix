{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  hey.hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAWO20sj075BlyT08kubpDUpbFFKjrz1YNo2CfTeVPWv";
  networking.networkmanager.enable = true;
  programs.wireshark.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    wayland.enable = true;
    enable = true;
  };
  environment.systemPackages = [
    pkgs.teams-for-linux
  ];

}
