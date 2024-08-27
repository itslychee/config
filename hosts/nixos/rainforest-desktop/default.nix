{pkgs, ...}: {
  boot = {
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  environment.systemPackages = [pkgs.remmina pkgs.libreoffice];

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGmZ4ydKauxo7XWxs7KBscNs+467oyFtC9jIevfiZOzv";
    caps = {
      headless = true;
      graphical = true;
    };
    users.lychee = {
      state = "24.05";
    };
  };
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  services.garage.enable = true;
  programs.gnupg.agent.enable = true;
  services.tailscale.ip = "100.123.212.62";
  hey.remote.builder = {
    enable = true;
    maxJobs = 5;
    speedFactor = 35;
  };

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  system.stateVersion = "24.05";
  services.consul.enable = true;
}
