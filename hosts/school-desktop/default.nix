{
  lib,
  config,
  pkgs,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.greetd.enable = lib.mkForce false;
  hey.caps = {
    headless = true;
    graphical = true;
  };
  hey.users.lychee = {
    state = "24.05";
    sshKeys = config.hey.keys.users.lychee.local_ssh;
  };

  environment.systemPackages = with pkgs; [
    nmap
    dnsutils
    john
    johnny
  ];

  system.stateVersion = "24.05";
}
