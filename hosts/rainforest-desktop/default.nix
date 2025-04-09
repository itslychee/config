{ pkgs, ... }:
{
  boot = {
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
  virtualisation.docker.enable = true;

  environment.systemPackages = [
    pkgs.minicom
    pkgs.libreoffice
    pkgs.gns3-gui
    (pkgs.vesktop.override {
      withMiddleClickScroll = true;
      withSystemVencord = true;
    })
  ];
  hey = {
    github.enable = false;

    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGmZ4ydKauxo7XWxs7KBscNs+467oyFtC9jIevfiZOzv";
    graphical.games = true;

    remote.builder = {
      enable = true;
      maxJobs = 5;
      speedFactor = 35;
    };
  };
  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    desktopManager = {
      plasma6.enable = true;
      plasma6.enableQt5Integration = true;
    };
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };

  networking.networkmanager.enable = true;
  programs.wireshark.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
}
