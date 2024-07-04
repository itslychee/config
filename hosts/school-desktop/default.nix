{config, ...}: {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  boot = {
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  services.desktopManager.plasma6.enable = true;
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiZ7kKvxTiMJNtybsRHeF6Po9rl8onUZr1aQ0mhTRwx";
    caps = {
      headless = true;
      graphical = true;
    };
    users.lychee = {
      state = "24.05";
    };
  };

  system.stateVersion = "24.05";
}
