{ pkgs, ... }:
{
  boot = {
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  environment.systemPackages = [
    pkgs.minicom
  ];

  hey.hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGmZ4ydKauxo7XWxs7KBscNs+467oyFtC9jIevfiZOzv";
  hey.graphical.games = true;
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
  };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  hey.remote.builder = {
    enable = true;
    maxJobs = 5;
    speedFactor = 35;
  };

  networking.networkmanager.enable = true;
  programs.wireshark.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
}
